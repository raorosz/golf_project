--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: league; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.league (
    leagueid integer NOT NULL,
    leaguename character varying(255) NOT NULL
);


ALTER TABLE public.league OWNER TO postgres;

--
-- Name: league_leagueid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.league_leagueid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.league_leagueid_seq OWNER TO postgres;

--
-- Name: league_leagueid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.league_leagueid_seq OWNED BY public.league.leagueid;


--
-- Name: players; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.players (
    playerid integer NOT NULL,
    firstname character varying(255) NOT NULL,
    lastname character varying(255) NOT NULL,
    handicap integer,
    leagueid integer
);


ALTER TABLE public.players OWNER TO postgres;

--
-- Name: players_playerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.players_playerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.players_playerid_seq OWNER TO postgres;

--
-- Name: players_playerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.players_playerid_seq OWNED BY public.players.playerid;


--
-- Name: scores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scores (
    scoreid integer NOT NULL,
    playerid integer,
    score integer,
    date date,
    teeboxid integer
);


ALTER TABLE public.scores OWNER TO postgres;

--
-- Name: scores_scoreid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scores_scoreid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scores_scoreid_seq OWNER TO postgres;

--
-- Name: scores_scoreid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scores_scoreid_seq OWNED BY public.scores.scoreid;


--
-- Name: teeboxes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teeboxes (
    teeboxid integer NOT NULL,
    teeboxname character varying(255),
    sloperating integer,
    courserating numeric(3,1),
    par integer
);


ALTER TABLE public.teeboxes OWNER TO postgres;

--
-- Name: teeboxes_teeboxid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teeboxes_teeboxid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teeboxes_teeboxid_seq OWNER TO postgres;

--
-- Name: teeboxes_teeboxid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teeboxes_teeboxid_seq OWNED BY public.teeboxes.teeboxid;


--
-- Name: league leagueid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.league ALTER COLUMN leagueid SET DEFAULT nextval('public.league_leagueid_seq'::regclass);


--
-- Name: players playerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players ALTER COLUMN playerid SET DEFAULT nextval('public.players_playerid_seq'::regclass);


--
-- Name: scores scoreid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scores ALTER COLUMN scoreid SET DEFAULT nextval('public.scores_scoreid_seq'::regclass);


--
-- Name: teeboxes teeboxid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teeboxes ALTER COLUMN teeboxid SET DEFAULT nextval('public.teeboxes_teeboxid_seq'::regclass);


--
-- Data for Name: league; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.league (leagueid, leaguename) FROM stdin;
78	Team 1
82	Team 2
83	Team 2
84	Team 1
85	Team 3
87	Team 4
88	Team 5
89	Team 4
90	Team 5
91	Team 6
92	Test 7
93	Team 10
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.players (playerid, firstname, lastname, handicap, leagueid) FROM stdin;
75	Robert	Orosz	2	78
79	Ale	Orosz	9	82
80	Tom	Sorenson 	5	83
81	Kyle 	Watson	4	84
82	Dustin	Schmidt	2	85
84	Robert	wolf	3	87
85	fred	Orosz	6	88
86	Robert	Sorenson 	29	89
87	Tom	Barker	2	90
88	Renata	Orosz	19	91
89	Kyle 	Sorenson 	-4	92
90	Scott	Spiridigliozzi	8	93
\.


--
-- Data for Name: scores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scores (scoreid, playerid, score, date, teeboxid) FROM stdin;
86	90	45	2024-03-27	3
78	82	29	2024-03-23	1
85	86	100	2024-03-21	3
68	82	33	2024-03-20	1
73	85	48	2024-03-20	4
67	75	40	2024-03-19	3
79	79	45	2024-03-19	1
55	75	40	2024-03-17	4
54	75	36	2024-03-16	3
53	75	43	2024-03-15	4
66	82	40	2024-03-14	1
72	85	44	2024-03-14	3
76	79	45	2024-03-13	8
51	75	41	2024-03-12	1
65	82	50	2024-03-12	2
77	79	42	2024-03-12	7
84	89	25	2024-03-12	1
62	81	41	2024-03-11	3
71	85	43	2024-03-11	3
74	86	30	2024-03-11	1
83	89	40	2024-03-11	1
58	79	36	2024-03-10	8
61	80	45	2024-03-10	5
64	82	40	2024-03-10	2
70	85	47	2024-03-10	4
57	79	55	2024-03-09	1
60	80	40	2024-03-09	6
63	82	45	2024-03-09	1
69	85	40	2024-03-09	3
56	79	40	2024-03-08	1
59	80	45	2024-03-08	5
\.


--
-- Data for Name: teeboxes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teeboxes (teeboxid, teeboxname, sloperating, courserating, par) FROM stdin;
1	Blue, Front 9	63	34.8	35
2	Blue, Back 9	63	34.8	36
3	White, Front 9	59	33.3	35
4	White, Back 9	59	33.3	36
5	Silver, Front 9	57	32.9	35
6	Silver, Back 9	57	32.9	36
7	Gold, Front 9	55	32.5	35
8	Gold, Back 9	55	32.5	36
\.


--
-- Name: league_leagueid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.league_leagueid_seq', 1, false);


--
-- Name: players_playerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.players_playerid_seq', 1, false);


--
-- Name: scores_scoreid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scores_scoreid_seq', 240, true);


--
-- Name: teeboxes_teeboxid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teeboxes_teeboxid_seq', 1, false);


--
-- Name: league unique_league_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.league
    ADD CONSTRAINT unique_league_id UNIQUE (leagueid);


--
-- Name: players unique_player_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT unique_player_id UNIQUE (playerid);


--
-- Name: scores unique_score_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scores
    ADD CONSTRAINT unique_score_id UNIQUE (scoreid);


--
-- Name: teeboxes unique_teebox_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teeboxes
    ADD CONSTRAINT unique_teebox_id UNIQUE (teeboxid);


--
-- PostgreSQL database dump complete
--

