using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using MySql.Data.MySqlClient;
using Npgsql;
using NpgsqlTypes;

namespace Worker
{
    class Program
    {
        static void Main(string[] args)
        {
            var mysqlConnectionString = "Server=mysql_db;Database=golf_db;Uid=root;Pwd=P@ssword;";
            var postgresConnectionString = "Host=postgres_db;Username=postgres;Password=P@ssword;Database=postgres;";



            while (true)
            {
                Thread.Sleep(5000); // Wait for 5 secondsbetween each iteration

                try
                {
                    using (var mysqlConnection = new MySqlConnection(mysqlConnectionString))
                    using (var postgresConnection = new NpgsqlConnection(postgresConnectionString))
                    {
                        mysqlConnection.Open();
                        postgresConnection.Open();

                        var data = FetchDataFromMySQL(mysqlConnection);
                        var newdata = FetchDataFromMySQL2(mysqlConnection);


                        CalculateAndStoreHandicap(data, mysqlConnection);

                        // Assume you have a list of player IDs and their corresponding handicaps
                        List<(int playerId, double handicap)> playerHandicaps = new List<(int playerId, double handicap)>
                        {
                            (1, 10.5),  // Example player ID and calculated handicap
                            (2, 8.2),   // Another example player ID and calculated handicap
                            // Add more player IDs and handicaps as needed
                        };

                        // Update handicaps for all players
                        foreach (var playerHandicap in playerHandicaps)
                        {
                            StoreOrUpdateHandicap(playerHandicap.playerId, playerHandicap.handicap, mysqlConnection);
                        }

                        // Insert all updated data from MySQL to PostgreSQL
                        InsertDataIntoPostgres(newdata, mysqlConnection, postgresConnection);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error: {ex.Message}");
                }
            }
        }

        static DataSet FetchDataFromMySQL(MySqlConnection connection)
        {
            var dataSet = new DataSet();
            var tables = new string[] { "players", "league", "scores", "teeboxes" };

            foreach (var table in tables)
            {
                var dataTable = new DataTable();
                string orderByClause = table == "scores" ? "ORDER BY Date DESC" : ""; // Only add ORDER BY clause for the 'scores' table
                using (var cmd = new MySqlCommand($"SELECT * FROM {table} {orderByClause}", connection))
                {
                    using (var reader = cmd.ExecuteReader())
                    {
                        dataTable.Load(reader);
                    }
                }
                dataSet.Tables.Add(dataTable);
            }
            // Print the contents of the DataSet
            //Console.WriteLine("Contents of DataSet:");
            //foreach (DataTable table in dataSet.Tables)
            //{
                //Console.WriteLine($"Table: {table.TableName}");
                //foreach (DataRow row in table.Rows)
                //{
                    //Console.WriteLine("Row:");
                    //foreach (var item in row.ItemArray)
                    //{
                        //Console.WriteLine($"   {item}");
                    //}
                //}
            //}

            return dataSet;
        }


        static DataSet FetchDataFromMySQL2(MySqlConnection connection)
        {
            var newdataSet = new DataSet();
            var tables = new string[] { "players", "league", "scores", "teeboxes" };

            foreach (var table in tables)
            {
                var dataTable = new DataTable();
                string orderByClause = table == "scores" ? "ORDER BY Date DESC" : ""; // Only add ORDER BY clause for the 'scores' table
                using (var cmd = new MySqlCommand($"SELECT * FROM {table} {orderByClause}", connection))
                {
                    using (var reader = cmd.ExecuteReader())
                    {
                        dataTable.Load(reader);
                    }
                }
                newdataSet.Tables.Add(dataTable);
            }
            // Print the contents of the DataSet
            //Console.WriteLine("Contents of DataSet:");
            //foreach (DataTable table in newdataSet.Tables)
            //{
                //Console.WriteLine($"Table: {table.TableName}");
                //foreach (DataRow row in table.Rows)
                //{
                    //Console.WriteLine("Row:");
                    //foreach (var item in row.ItemArray)
                    //{
                        //Console.WriteLine($"   {item}");
                    //}
                //}
            //}

            return newdataSet;
        }


        
        static void CalculateAndStoreHandicap(DataSet data, MySqlConnection mySqlConnection)
        {
            // Check the number of players fetched
            //Console.WriteLine($"Total players fetched: {data.Tables["players"].Rows.Count}");
            foreach (DataRow playerRow in data.Tables["players"].Rows)
            {
                int playerId = Convert.ToInt32(playerRow["PlayerID"]);

                // Get the player's last 5 scores
                var playerScores = data.Tables["scores"].AsEnumerable()
                    .Where(row => Convert.ToInt32(row["PlayerID"]) == playerId)
                    .OrderByDescending(row => row["Date"])
                    .Take(5)
                    .ToList();

                if (playerScores.Any())
                {

                    // Calculate handicap index as the average of the last 5 scores
                    var handicapIndex = CalculateHandicapIndex(playerScores);

                    // Fetch slope rating, course rating, and par based on the TeeboxID from the last score
                    int lastTeeboxId = Convert.ToInt32(playerScores.FirstOrDefault()?["TeeboxID"]);
                    var teebox = data.Tables["teeboxes"].AsEnumerable()
                        .FirstOrDefault(row => Convert.ToInt32(row["TeeboxID"]) == lastTeeboxId);
                
                    if (teebox != null)
                    {
                        int slopeRating = Convert.ToInt32(teebox["SlopeRating"]);
                        decimal courseRating = Convert.ToDecimal(teebox["CourseRating"]);
                        int par = Convert.ToInt32(teebox["Par"]);

                        // Calculate the differential for each score and compute the average
                        double differentialSum = playerScores.Sum(row =>
                            (Convert.ToInt32(row["Score"]) - par) * 113.0 / slopeRating);
                        double averageDifferential = differentialSum / playerScores.Count;
                        
                        
                        // Calculate the handicap using the provided formula
                        double handicap = ((handicapIndex - 36)) * ((slopeRating) / 56.5) + (Convert.ToDouble(courseRating) - par);

                        //Console.WriteLine(handicapIndex);
                        //Console.WriteLine(handicap);
                        //Console.WriteLine(slopeRating);
                        //Console.WriteLine(courseRating);
                        //Console.WriteLine(par);

                        // Store or update the handicap for the player using the provided method
                        StoreOrUpdateHandicap(playerId, handicap, mySqlConnection);
                    }
                    else
                    {
                        Console.WriteLine($"Teebox for the last score not found for player with ID {playerId}.");
                    }
                }
                else
                {
                    Console.WriteLine($"No scores found for player with ID {playerId}.");
                }    
            }
        }


        static double CalculateHandicapIndex(List<DataRow> playerScores)
        {
            // Extract scores from each DataRow and convert them to doubles
            var scores = playerScores.Select(row => Convert.ToDouble(row["Score"]));

            // Print out all the scores
            //Console.WriteLine("Scores:");
            //foreach (var score in scores)
            //{
                //Console.WriteLine(score);
            //}

            // Calculate the average of the scores
            double averageScore = scores.Average();

            // Print out the average score
            //Console.WriteLine($"Average Score: {averageScore}");

            return averageScore;
        }


        static void StoreOrUpdateHandicap(int playerId, double handicap, MySqlConnection mysqlConnection)
        {
            try
            {
                Console.WriteLine($"Updating handicap for player ID: {playerId}"); // Print playerId
                using (var cmd = new MySqlCommand("UPDATE players SET Handicap = @handicap WHERE PlayerID = @playerId", mysqlConnection))
                {
                    cmd.Parameters.AddWithValue("@handicap", handicap);
                    cmd.Parameters.AddWithValue("@playerId", playerId);
                    
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected == 0)
                    {
                        Console.WriteLine($"Player with ID {playerId} not found in the database.");
                    }
                    else
                    {
                        Console.WriteLine($"Handicap updated successfully for player with ID {playerId}.");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error updating handicap for player {playerId}: {ex.Message}");
            }
        }

        static void InsertDataIntoPostgres(DataSet newdata, MySqlConnection mysqlConnection, NpgsqlConnection postgresConnection)
        {
            try
            {
                // Truncate tables in PostgreSQL before inserting new data
                TruncatePostgresTables(postgresConnection);

                // Transfer data from each table in the DataSet to PostgreSQL
                foreach (DataTable table in newdata.Tables)
                {
                    TransferDataToPostgres(table, table.TableName, postgresConnection);
                }
            }
            catch (Exception ex)
            {
                // Log the error to a file or logging service
                Console.WriteLine($"Error inserting data into PostgreSQL: {ex.Message}");
            }
        }
    
    
        static void TruncatePostgresTables(NpgsqlConnection postgresConnection)
        {
            try
            {
                using (var cmd = new NpgsqlCommand("TRUNCATE TABLE players, league, scores, teeboxes", postgresConnection))
                {
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error truncating PostgreSQL tables: {ex.Message}");
                // Log the error to a file or logging service
            }
        }    
    

        static void TransferDataToPostgres(DataTable dataTable, string tableName, NpgsqlConnection connection)
        {
            Console.WriteLine($"Transferring data for table: {tableName}");
            
            foreach (DataRow row in dataTable.Rows)
            {
                Console.WriteLine("Row:");
                foreach (var item in row.ItemArray)
                {
                    Console.WriteLine($"   {item}");
                }
            }
            
            using (var writer = connection.BeginBinaryImport($"COPY {tableName} FROM STDIN (FORMAT BINARY)"))
            {
                foreach (DataRow row in dataTable.Rows)
                {
                    writer.StartRow();
                    foreach (var item in row.ItemArray)
                    {
                        if (item is int)
                            writer.Write(Convert.ToInt32(item), NpgsqlDbType.Integer);
                        else if (item is string)
                            writer.Write(item.ToString(), NpgsqlDbType.Text);
                        else if (item is DateTime)
                            writer.Write(Convert.ToDateTime(item), NpgsqlDbType.Date);
                        else if (item is decimal)
                            writer.Write(Convert.ToDecimal(item), NpgsqlDbType.Numeric);
                        // Add more type checks as needed
                    }
                }
                writer.Complete();
            }
        }
    
    }       
}