--
-- PostgreSQL database dump
--

\restrict PoYtjn57SYHsEJPKFozey7bDzsTODCD2elC8Diw7TVwDGeupRHtBV78bSdrvAem

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-11-19 16:37:02

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 228 (class 1259 OID 16616)
-- Name: clases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clases (
    id_clase integer NOT NULL,
    nombre character varying(100) NOT NULL,
    dia_semana character varying(20) NOT NULL,
    hora character varying(20) NOT NULL,
    cupo integer NOT NULL,
    id_entrenador integer,
    estado character varying(20) DEFAULT 'activa'::character varying NOT NULL,
    CONSTRAINT chk_estado_clase CHECK (((estado)::text = ANY ((ARRAY['activa'::character varying, 'suspendida'::character varying])::text[])))
);


ALTER TABLE public.clases OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16615)
-- Name: clases_id_clase_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clases_id_clase_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clases_id_clase_seq OWNER TO postgres;

--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 227
-- Name: clases_id_clase_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clases_id_clase_seq OWNED BY public.clases.id_clase;


--
-- TOC entry 226 (class 1259 OID 16605)
-- Name: entrenadores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entrenadores (
    id_entrenador integer NOT NULL,
    nombre character varying(100) NOT NULL,
    especialidad character varying(100),
    correo character varying(100)
);


ALTER TABLE public.entrenadores OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16604)
-- Name: entrenadores_id_entrenador_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.entrenadores_id_entrenador_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.entrenadores_id_entrenador_seq OWNER TO postgres;

--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 225
-- Name: entrenadores_id_entrenador_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.entrenadores_id_entrenador_seq OWNED BY public.entrenadores.id_entrenador;


--
-- TOC entry 220 (class 1259 OID 16560)
-- Name: fichas_medicas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fichas_medicas (
    documento character varying(20) NOT NULL,
    peso numeric(5,2),
    estatura numeric(3,2),
    lesiones character varying(50)
);


ALTER TABLE public.fichas_medicas OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16633)
-- Name: inscripciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inscripciones (
    documento character varying(20) NOT NULL,
    id_clase integer NOT NULL,
    fecha_inscripcion date NOT NULL
);


ALTER TABLE public.inscripciones OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16583)
-- Name: membresias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membresias (
    id_membresia integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    documento character varying(20) NOT NULL,
    id_plan integer,
    valor_pagado numeric(8,2) NOT NULL,
    CONSTRAINT chk_fechas CHECK ((fecha_fin > fecha_inicio)),
    CONSTRAINT chk_valor_pagado CHECK ((valor_pagado > (0)::numeric))
);


ALTER TABLE public.membresias OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16582)
-- Name: membresias_id_membresia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.membresias_id_membresia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.membresias_id_membresia_seq OWNER TO postgres;

--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 223
-- Name: membresias_id_membresia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.membresias_id_membresia_seq OWNED BY public.membresias.id_membresia;


--
-- TOC entry 231 (class 1259 OID 16698)
-- Name: ocupacion_clases; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.ocupacion_clases AS
 SELECT count(i.documento) AS total_inscrito,
    c.nombre,
    c.cupo,
    c.dia_semana,
    c.hora
   FROM (public.clases c
     LEFT JOIN public.inscripciones i ON ((c.id_clase = i.id_clase)))
  WHERE ((c.estado)::text ~~* 'activa'::text)
  GROUP BY c.nombre, c.cupo, c.dia_semana, c.hora;


ALTER VIEW public.ocupacion_clases OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16572)
-- Name: planes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.planes (
    id_plan integer NOT NULL,
    nombre character varying(50) NOT NULL,
    duracion_meses integer NOT NULL,
    precio numeric(10,2) NOT NULL
);


ALTER TABLE public.planes OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16571)
-- Name: planes_id_plan_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.planes_id_plan_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.planes_id_plan_seq OWNER TO postgres;

--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 221
-- Name: planes_id_plan_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.planes_id_plan_seq OWNED BY public.planes.id_plan;


--
-- TOC entry 219 (class 1259 OID 16550)
-- Name: socios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.socios (
    documento character varying(20) NOT NULL,
    nombre character varying(100) NOT NULL,
    telefono character varying(20),
    correo character varying(100),
    acepta_whatsapp character varying(3) DEFAULT 'no'::character varying NOT NULL,
    CONSTRAINT chk_acepta_whatsapp CHECK (((acepta_whatsapp)::text = ANY ((ARRAY['no'::character varying, 'si'::character varying])::text[])))
);


ALTER TABLE public.socios OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16693)
-- Name: socios_vencidos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.socios_vencidos AS
SELECT
    NULL::character varying(100) AS nombre,
    NULL::character varying(20) AS telefono,
    NULL::character varying(3) AS acepta_whatsapp,
    NULL::date AS ultima_fecha;


ALTER VIEW public.socios_vencidos OWNER TO postgres;

--
-- TOC entry 4895 (class 2604 OID 16619)
-- Name: clases id_clase; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clases ALTER COLUMN id_clase SET DEFAULT nextval('public.clases_id_clase_seq'::regclass);


--
-- TOC entry 4894 (class 2604 OID 16608)
-- Name: entrenadores id_entrenador; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entrenadores ALTER COLUMN id_entrenador SET DEFAULT nextval('public.entrenadores_id_entrenador_seq'::regclass);


--
-- TOC entry 4893 (class 2604 OID 16586)
-- Name: membresias id_membresia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membresias ALTER COLUMN id_membresia SET DEFAULT nextval('public.membresias_id_membresia_seq'::regclass);


--
-- TOC entry 4892 (class 2604 OID 16575)
-- Name: planes id_plan; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planes ALTER COLUMN id_plan SET DEFAULT nextval('public.planes_id_plan_seq'::regclass);


--
-- TOC entry 5085 (class 0 OID 16616)
-- Dependencies: 228
-- Data for Name: clases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clases (id_clase, nombre, dia_semana, hora, cupo, id_entrenador, estado) FROM stdin;
2	Spinning	Martes	10:00	15	3	activa
3	Musculacion	Miercoles	14:00	25	1	activa
4	Yoga avanzado	Viernes	16:00	15	2	activa
1	Yoga	Lunes	08:00	20	2	suspendida
5	Pilates	Viernes	18:00	12	1	activa
\.


--
-- TOC entry 5083 (class 0 OID 16605)
-- Dependencies: 226
-- Data for Name: entrenadores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entrenadores (id_entrenador, nombre, especialidad, correo) FROM stdin;
1	Pedro Ramirez	Musculacion	pedro@gmail.com
2	Ana Martinez	Yoga	ana@gmail.com
3	Luis Herrera	Spinning	luis@gmail.com
4	Jaime Garzon	Pilates	jaime.garx@gmail.com
\.


--
-- TOC entry 5077 (class 0 OID 16560)
-- Dependencies: 220
-- Data for Name: fichas_medicas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fichas_medicas (documento, peso, estatura, lesiones) FROM stdin;
1001	75.50	1.75	Ninguna
1002	60.00	1.62	Lesion de rodilla
1003	82.30	1.80	Ninguna
1004	55.80	1.60	Lesion de espalda
1005	90.00	1.85	Ninguna
\.


--
-- TOC entry 5086 (class 0 OID 16633)
-- Dependencies: 229
-- Data for Name: inscripciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inscripciones (documento, id_clase, fecha_inscripcion) FROM stdin;
1001	1	2026-01-02
1001	2	2026-01-03
1002	1	2026-01-04
1002	3	2026-01-05
1003	2	2026-01-06
1003	4	2026-01-07
1004	1	2026-01-08
1005	3	2026-01-09
1002	2	2026-11-19
1004	2	2026-11-19
1005	2	2026-11-19
1006	2	2026-11-19
1007	5	2026-11-19
\.


--
-- TOC entry 5081 (class 0 OID 16583)
-- Dependencies: 224
-- Data for Name: membresias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membresias (id_membresia, fecha_inicio, fecha_fin, documento, id_plan, valor_pagado) FROM stdin;
1	2026-01-01	2026-02-01	1001	1	80000.00
2	2026-02-01	2026-05-01	1001	2	210000.00
3	2026-01-15	2026-02-15	1002	1	700000.00
4	2026-03-01	2027-03-01	1003	3	70000.00
5	2026-02-10	2026-05-10	1004	2	210000.00
6	2026-04-01	2026-05-01	1005	1	80000.00
7	2026-01-15	2026-02-15	1002	1	80000.00
9	2026-09-01	2026-10-01	1006	1	80000.00
10	2026-10-01	2026-11-01	1006	2	210000.00
11	2026-11-01	2026-12-01	1006	1	80000.00
12	2026-09-15	2026-10-15	1007	3	700000.00
13	2026-11-05	2026-12-05	1001	1	80000.00
14	2026-11-10	2027-02-10	1002	2	200000.00
\.


--
-- TOC entry 5079 (class 0 OID 16572)
-- Dependencies: 222
-- Data for Name: planes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.planes (id_plan, nombre, duracion_meses, precio) FROM stdin;
1	Mensual	1	80000.00
2	Trimestral	3	210000.00
3	Anual	12	750000.00
\.


--
-- TOC entry 5076 (class 0 OID 16550)
-- Dependencies: 219
-- Data for Name: socios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.socios (documento, nombre, telefono, correo, acepta_whatsapp) FROM stdin;
1002	Isabel Sarrazola	3019876543	isabel22@gmail.com	no
1004	Kevin Jaramillo	3007654321	kevin4@gmail.com	no
1005	Miguel Aguirre	3002467816	miguel10@gmail.com	no
1001	Maria Aristizabal	3003844509	maria18@gmail.com	si
1003	Cristian Valencia	3024567890	cristian5@gmail.com	si
1006	David Mora	3012579468	\N	si
1007	Santiago Jaramillo	3140217854	santij7@gmail.com	no
\.


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 227
-- Name: clases_id_clase_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clases_id_clase_seq', 4, true);


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 225
-- Name: entrenadores_id_entrenador_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.entrenadores_id_entrenador_seq', 3, true);


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 223
-- Name: membresias_id_membresia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.membresias_id_membresia_seq', 14, true);


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 221
-- Name: planes_id_plan_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.planes_id_plan_seq', 3, true);


--
-- TOC entry 4916 (class 2606 OID 16662)
-- Name: clases chk_clase_unica; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clases
    ADD CONSTRAINT chk_clase_unica UNIQUE (id_entrenador, dia_semana, hora);


--
-- TOC entry 4918 (class 2606 OID 16627)
-- Name: clases clases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clases
    ADD CONSTRAINT clases_pkey PRIMARY KEY (id_clase);


--
-- TOC entry 4912 (class 2606 OID 16614)
-- Name: entrenadores entrenadores_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entrenadores
    ADD CONSTRAINT entrenadores_correo_key UNIQUE (correo);


--
-- TOC entry 4914 (class 2606 OID 16612)
-- Name: entrenadores entrenadores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entrenadores
    ADD CONSTRAINT entrenadores_pkey PRIMARY KEY (id_entrenador);


--
-- TOC entry 4906 (class 2606 OID 16565)
-- Name: fichas_medicas fichas_medicas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fichas_medicas
    ADD CONSTRAINT fichas_medicas_pkey PRIMARY KEY (documento);


--
-- TOC entry 4920 (class 2606 OID 16640)
-- Name: inscripciones inscripciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscripciones
    ADD CONSTRAINT inscripciones_pkey PRIMARY KEY (documento, id_clase);


--
-- TOC entry 4910 (class 2606 OID 16593)
-- Name: membresias membresias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membresias
    ADD CONSTRAINT membresias_pkey PRIMARY KEY (id_membresia);


--
-- TOC entry 4908 (class 2606 OID 16581)
-- Name: planes planes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planes
    ADD CONSTRAINT planes_pkey PRIMARY KEY (id_plan);


--
-- TOC entry 4902 (class 2606 OID 16559)
-- Name: socios socios_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socios
    ADD CONSTRAINT socios_correo_key UNIQUE (correo);


--
-- TOC entry 4904 (class 2606 OID 16557)
-- Name: socios socios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socios
    ADD CONSTRAINT socios_pkey PRIMARY KEY (documento);


--
-- TOC entry 5074 (class 2618 OID 16696)
-- Name: socios_vencidos _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.socios_vencidos AS
 SELECT s.nombre,
    s.telefono,
    s.acepta_whatsapp,
    max(m.fecha_fin) AS ultima_fecha
   FROM (public.socios s
     JOIN public.membresias m ON (((s.documento)::text = (m.documento)::text)))
  GROUP BY s.documento, s.telefono, s.acepta_whatsapp
 HAVING (max(m.fecha_fin) < CURRENT_DATE);


--
-- TOC entry 4924 (class 2606 OID 16678)
-- Name: clases fk_clase_entrenador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clases
    ADD CONSTRAINT fk_clase_entrenador FOREIGN KEY (id_entrenador) REFERENCES public.entrenadores(id_entrenador) ON DELETE SET NULL;


--
-- TOC entry 4921 (class 2606 OID 16663)
-- Name: fichas_medicas fk_ficha_socio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fichas_medicas
    ADD CONSTRAINT fk_ficha_socio FOREIGN KEY (documento) REFERENCES public.socios(documento) ON DELETE CASCADE;


--
-- TOC entry 4925 (class 2606 OID 16688)
-- Name: inscripciones fk_inscripcion_clase; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscripciones
    ADD CONSTRAINT fk_inscripcion_clase FOREIGN KEY (id_clase) REFERENCES public.clases(id_clase) ON DELETE CASCADE;


--
-- TOC entry 4926 (class 2606 OID 16683)
-- Name: inscripciones fk_inscripcion_socio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inscripciones
    ADD CONSTRAINT fk_inscripcion_socio FOREIGN KEY (documento) REFERENCES public.socios(documento) ON DELETE CASCADE;


--
-- TOC entry 4922 (class 2606 OID 16673)
-- Name: membresias fk_membresia_plan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membresias
    ADD CONSTRAINT fk_membresia_plan FOREIGN KEY (id_plan) REFERENCES public.planes(id_plan) ON DELETE SET NULL;


--
-- TOC entry 4923 (class 2606 OID 16668)
-- Name: membresias fk_membresia_socio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membresias
    ADD CONSTRAINT fk_membresia_socio FOREIGN KEY (documento) REFERENCES public.socios(documento) ON DELETE CASCADE;


-- Completed on 2026-11-19 16:37:02

--
-- PostgreSQL database dump complete
--

\unrestrict PoYtjn57SYHsEJPKFozey7bDzsTODCD2elC8Diw7TVwDGeupRHtBV78bSdrvAem

