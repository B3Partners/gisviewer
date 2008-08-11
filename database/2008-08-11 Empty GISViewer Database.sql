--
-- PostgreSQL database dump
--
-- Started on 2007-11-09 14:55:08
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET default_tablespace = '';
SET default_with_oids = false;

--
-- TOC entry 2092 (class 1259 OID 5952132)
-- Dependencies: 2503 2504 2505 2506 2507 2508 2509 2510 5
-- Name: applicaties; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE applicaties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.applicaties_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('applicaties_id_seq', 1, false);

CREATE TABLE applicaties (
    id integer DEFAULT nextval('applicaties_id_seq'::regclass) NOT NULL,
    pakket character varying(255),
    module character varying(255),
    beschrijving character varying(255),
    taal character varying(255),
    spatial_koppeling character varying(255),
    db_koppeling character varying(255),
    opmerking character varying(255),
    leverancier integer,
    extern boolean DEFAULT false NOT NULL,
    acceptabel boolean DEFAULT false NOT NULL,
    administratief boolean DEFAULT false NOT NULL,
    geodata boolean DEFAULT false NOT NULL,
    webbased boolean DEFAULT false NOT NULL,
    gps boolean DEFAULT false NOT NULL,
    crow boolean DEFAULT false NOT NULL
);

ALTER TABLE public.applicaties OWNER TO postgres;

--
-- TOC entry 2098 (class 1259 OID 5952185)
-- Dependencies: 2511 5
-- Name: clusters; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE clusters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.clusters_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('clusters_id_seq', 1, false);

CREATE TABLE clusters (
    id integer DEFAULT nextval('clusters_id_seq'::regclass) NOT NULL,
    naam character varying(255),
    omschrijving character varying(255),
    parent integer
);

ALTER TABLE public.clusters OWNER TO postgres;

--
-- TOC entry 2101 (class 1259 OID 5952199)
-- Dependencies: 2512 5
-- Name: data_typen; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE data_typen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.data_typen_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('data_typen_id_seq', 1, false);

CREATE TABLE data_typen (
    id integer DEFAULT nextval('data_typen_id_seq'::regclass) NOT NULL,
    naam character varying(255)
);

ALTER TABLE public.data_typen OWNER TO postgres;

--
-- TOC entry 2105 (class 1259 OID 5952254)
-- Dependencies: 2516 5
-- Name: etl_proces; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE etlproces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.etlproces_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('etlproces_id_seq', 1, false);
SET default_with_oids = false;

CREATE TABLE etl_proces (
    id integer DEFAULT nextval('etlproces_id_seq'::regclass) NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone
);

ALTER TABLE public.etl_proces OWNER TO postgres;

--
-- TOC entry 2107 (class 1259 OID 5952258)
-- Dependencies: 2517 2518 2519 5
-- Name: functie_items; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE functie_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.functie_items_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('functie_items_id_seq', 1, false);

CREATE TABLE functie_items (
    id integer DEFAULT nextval('functie_items_id_seq'::regclass) NOT NULL,
    label character varying(255),
    omschrijving character varying(255),
    eenheid character varying(255),
    voorbeelden character varying(255),
    functie integer,
    invoer boolean DEFAULT false NOT NULL,
    uitvoer boolean DEFAULT false NOT NULL
);

ALTER TABLE public.functie_items OWNER TO postgres;

SET default_with_oids = true;

--
-- TOC entry 2113 (class 1259 OID 5952320)
-- Dependencies: 2520 2521 5
-- Name: leveranciers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE leveranciers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.leveranciers_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('leveranciers_id_seq', 1, false);

SET default_with_oids = false;

CREATE TABLE leveranciers (
    id integer DEFAULT nextval('leveranciers_id_seq'::regclass) NOT NULL,
    naam character varying(255),
    pakket character varying(255),
    telefoon1 character varying(255),
    contact character varying(255),
    telefoon2 character varying(255),
    telefoon3 character varying(255),
    email character varying(255),
    opmerkingen character varying(255),
    info boolean DEFAULT false NOT NULL
);

ALTER TABLE public.leveranciers OWNER TO postgres;

--
-- TOC entry 2115 (class 1259 OID 5952336)
-- Dependencies: 2522 5
-- Name: locatie_aanduidingen; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE locatie_aanduidingen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.locatie_aanduidingen_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('locatie_aanduidingen_id_seq', 1, false);

CREATE TABLE locatie_aanduidingen (
    id integer DEFAULT nextval('locatie_aanduidingen_id_seq'::regclass) NOT NULL,
    naam character varying(255),
    omschrijving character varying(255)
);

ALTER TABLE public.locatie_aanduidingen OWNER TO postgres;

--
-- TOC entry 2118 (class 1259 OID 5952351)
-- Dependencies: 2523 5
-- Name: medewerkers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE medewerkers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.medewerkers_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('medewerkers_id_seq', 1, false);

CREATE TABLE medewerkers (
    id integer DEFAULT nextval('medewerkers_id_seq'::regclass) NOT NULL,
    achternaam character varying(255),
    voornaam character varying(255),
    telefoon character varying(255),
    functie character varying(255),
    locatie character varying(255),
    email character varying(255)
);

ALTER TABLE public.medewerkers OWNER TO postgres;

--
-- TOC entry 2120 (class 1259 OID 5952355)
-- Dependencies: 2524 5
-- Name: moscow; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE moscow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.moscow_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('moscow_id_seq', 1, false);

CREATE TABLE moscow (
    id integer DEFAULT nextval('moscow_id_seq'::regclass) NOT NULL,
    code character varying(255),
    naam character varying(255),
    omschrijving character varying(255)
);

ALTER TABLE public.moscow OWNER TO postgres;

SET default_with_oids = true;


--
-- TOC entry 2124 (class 1259 OID 5952369)
-- Dependencies: 2528 2529 5
-- Name: onderdeel; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE onderdeel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.onderdeel_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('onderdeel_id_seq', 1, false);

SET default_with_oids = false;

CREATE TABLE onderdeel (
    id integer DEFAULT nextval('onderdeel_id_seq'::regclass) NOT NULL,
    naam character varying(255),
    omschrijving character varying(255),
    locatie character varying(255),
    regio boolean DEFAULT false NOT NULL
);

ALTER TABLE public.onderdeel OWNER TO postgres;

--
-- TOC entry 2126 (class 1259 OID 5952374)
-- Dependencies: 2530 2531 5
-- Name: onderdeel_medewerkers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE onderdeel_medewerkers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

ALTER TABLE public.onderdeel_medewerkers_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('onderdeel_medewerkers_id_seq', 1, false);

CREATE TABLE onderdeel_medewerkers (
    id integer DEFAULT nextval('onderdeel_medewerkers_id_seq'::regclass) NOT NULL,
    medewerker integer,
    onderdeel integer,
    vertegenwoordiger boolean DEFAULT false NOT NULL
);

ALTER TABLE public.onderdeel_medewerkers OWNER TO postgres;

--
-- TOC entry 2131 (class 1259 OID 5952409)
-- Dependencies: 2532 5
-- Name: rollen; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE rollen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.rollen_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('rollen_id_seq', 1, false);

CREATE TABLE rollen (
    id integer DEFAULT nextval('rollen_id_seq'::regclass) NOT NULL,
    naam character varying(255)
);

ALTER TABLE public.rollen OWNER TO postgres;


--
-- TOC entry 2138 (class 1259 OID 5952453)
-- Dependencies: 2537 2538 2539 2540 2541 2542 2543 5
-- Name: thema_applicaties; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE thema_applicaties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.thema_applicaties_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('thema_applicaties_id_seq', 1, false);

SET default_with_oids = false;

CREATE TABLE thema_applicaties (
    id integer DEFAULT nextval('thema_applicaties_id_seq'::regclass) NOT NULL,
    thema integer,
    applicatie integer,
    ingebruik boolean DEFAULT false NOT NULL,
    geodata boolean DEFAULT false NOT NULL,
    administratief boolean DEFAULT false NOT NULL,
    voorkeur boolean DEFAULT false NOT NULL,
    definitief boolean DEFAULT false NOT NULL,
    standaard boolean DEFAULT false NOT NULL
);

ALTER TABLE public.thema_applicaties OWNER TO postgres;

--
-- TOC entry 2140 (class 1259 OID 5952463)
-- Dependencies: 2544 2545 5
-- Name: thema_data; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE thema_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

ALTER TABLE public.thema_data_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('thema_data_id_seq', 1, false);

CREATE TABLE thema_data (
    id integer DEFAULT nextval('thema_data_id_seq'::regclass) NOT NULL,
    label character varying(255),
    eenheid character varying(255),
    omschrijving character varying(255),
    voorbeelden character varying(255),
    kolombreedte integer NOT NULL,
    thema integer,
    moscow integer,
    waarde_type integer,
    kolomnaam character varying(255),
    data_type integer,
    commando text,
    basisregel boolean DEFAULT false NOT NULL,
    dataorder integer
);

ALTER TABLE public.thema_data OWNER TO postgres;

--
-- TOC entry 2142 (class 1259 OID 5952471)
-- Dependencies: 2546 5
-- Name: thema_functies; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE thema_functies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.thema_functies_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('thema_functies_id_seq', 1, false);

CREATE TABLE thema_functies (
    id integer DEFAULT nextval('thema_functies_id_seq'::regclass) NOT NULL,
    naam character varying(255),
    omschrijving character varying(255),
    thema integer,
    applicatie integer,
    protocol character varying(255)
);

ALTER TABLE public.thema_functies OWNER TO postgres;

--
-- TOC entry 2144 (class 1259 OID 5952475)
-- Dependencies: 2547 2548 2549 5
-- Name: thema_verantwoordelijkheden; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE thema_verantwoordelijkheden_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.thema_verantwoordelijkheden_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('thema_verantwoordelijkheden_id_seq', 1, false);

CREATE TABLE thema_verantwoordelijkheden (
    id integer DEFAULT nextval('thema_verantwoordelijkheden_id_seq'::regclass) NOT NULL,
    thema integer,
    medewerker integer,
    onderdeel integer,
    rol integer,
    opmerkingen text,
    huidige_situatie boolean DEFAULT false NOT NULL,
    gewenste_situatie boolean DEFAULT false NOT NULL,
    competenties_kennis character varying(255)
);

ALTER TABLE public.thema_verantwoordelijkheden OWNER TO postgres;

--
-- TOC entry 2146 (class 1259 OID 5952484)
-- Dependencies: 2550 2551 2552 2553 2554 2555 5
-- Name: themas; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE themas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.themas_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('themas_id_seq', 1, false);

CREATE TABLE themas (
    id integer DEFAULT nextval('themas_id_seq'::regclass) NOT NULL,
    code character varying(255),
    naam character varying(255),
    moscow integer,
    belangnr integer NOT NULL,
    "cluster" integer NOT NULL,
    opmerkingen text,
    admin_tabel_opmerkingen text,
    admin_tabel character varying(255),
    admin_pk character varying(255),
    admin_spatial_ref character varying(255),
    admin_query character varying(255),
    spatial_tabel_opmerkingen text,
    spatial_tabel character varying(255),
    spatial_pk character varying(255),
    spatial_admin_ref character varying(255),
    analyse_thema boolean DEFAULT false NOT NULL,
    locatie_thema boolean DEFAULT false NOT NULL,
    admin_pk_complex boolean DEFAULT false NOT NULL,
    spatial_pk_complex boolean DEFAULT false NOT NULL,
    wms_url character varying,
    wms_layers character varying,
    wms_querylayers character varying,
    update_frequentie_in_dagen integer,
    omvang_thema character varying(4),
    wms_legendlayer character varying,
    view_geomtype character varying(30),
    wms_layers_real character varying,
    wms_querylayers_real character varying,
    wms_legendlayer_real character varying,
    visible boolean DEFAULT false NOT NULL
);

ALTER TABLE public.themas OWNER TO postgres;

--
-- TOC entry 2153 (class 1259 OID 5952565)
-- Dependencies: 2556 5
-- Name: waarde_typen; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE waarde_typen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.waarde_typen_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('waarde_typen_id_seq', 1, false);

CREATE TABLE waarde_typen (
    id integer DEFAULT nextval('waarde_typen_id_seq'::regclass) NOT NULL,
    naam character varying(255)
);

ALTER TABLE public.waarde_typen OWNER TO postgres;

--
-- TOC entry 2156 (class 1259 OID 5952579)
-- Dependencies: 2557 2558 5
-- Name: workshop_medewerkers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE workshop_medewerkers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.workshop_medewerkers_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('workshop_medewerkers_id_seq', 1, false);

CREATE TABLE workshop_medewerkers (
    id integer DEFAULT nextval('workshop_medewerkers_id_seq'::regclass) NOT NULL,
    workshop integer,
    medewerker integer,
    baanwezig bit varying NOT NULL,
    aanwezig boolean DEFAULT false
);

ALTER TABLE public.workshop_medewerkers OWNER TO postgres;

--
-- TOC entry 2158 (class 1259 OID 5952587)
-- Dependencies: 2559 5
-- Name: workshops; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
CREATE SEQUENCE workshops_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.workshops_id_seq OWNER TO postgres;

SELECT pg_catalog.setval('workshops_id_seq', 1, false);

CREATE TABLE workshops (
    id integer DEFAULT nextval('workshops_id_seq'::regclass) NOT NULL,
    volgnr integer NOT NULL,
    naam character varying(255)
);

ALTER TABLE public.workshops OWNER TO postgres;

--
-- ALTER TABLES
--

ALTER TABLE ONLY applicaties ADD CONSTRAINT applicaties_pkey PRIMARY KEY (id);
ALTER TABLE ONLY clusters ADD CONSTRAINT clusters_pkey PRIMARY KEY (id);
ALTER TABLE ONLY data_typen ADD CONSTRAINT data_types_pkey1 PRIMARY KEY (id);
ALTER TABLE ONLY functie_items ADD CONSTRAINT functie_items_pkey PRIMARY KEY (id);
--ALTER TABLE ONLY geometry_columns ADD CONSTRAINT geometry_columns_pk PRIMARY KEY (f_table_catalog, f_table_schema, f_table_name, f_geometry_column);
ALTER TABLE ONLY leveranciers ADD CONSTRAINT leveranciers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY locatie_aanduidingen ADD CONSTRAINT locatie_aanduidingen_pkey PRIMARY KEY (id);
ALTER TABLE ONLY medewerkers ADD CONSTRAINT medewerkers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY moscow ADD CONSTRAINT moscow_pkey PRIMARY KEY (id);
ALTER TABLE ONLY onderdeel_medewerkers ADD CONSTRAINT onderdeel_medewerkers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY onderdeel ADD CONSTRAINT onderdeel_pkey PRIMARY KEY (id);
ALTER TABLE ONLY etl_proces ADD CONSTRAINT pk_etlproces PRIMARY KEY (id);
ALTER TABLE ONLY rollen ADD CONSTRAINT rollen_pkey PRIMARY KEY (id);
--ALTER TABLE ONLY spatial_ref_sys ADD CONSTRAINT spatial_ref_sys_pkey PRIMARY KEY (srid);
ALTER TABLE ONLY thema_applicaties ADD CONSTRAINT thema_applicaties_pkey PRIMARY KEY (id);
ALTER TABLE ONLY thema_data ADD CONSTRAINT thema_data_pkey PRIMARY KEY (id);
ALTER TABLE ONLY thema_functies ADD CONSTRAINT thema_functies_pkey PRIMARY KEY (id);
ALTER TABLE ONLY thema_verantwoordelijkheden ADD CONSTRAINT thema_verantwoordelijkheden_pkey PRIMARY KEY (id);
ALTER TABLE ONLY themas ADD CONSTRAINT themas_pkey PRIMARY KEY (id);
ALTER TABLE ONLY waarde_typen ADD CONSTRAINT waarde_typen_pkey PRIMARY KEY (id);
ALTER TABLE ONLY workshop_medewerkers ADD CONSTRAINT workshop_medewerkers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY workshops ADD CONSTRAINT workshops_pkey PRIMARY KEY (id);
ALTER TABLE ONLY applicaties ADD CONSTRAINT applicaties_leverancier_fkey FOREIGN KEY (leverancier) REFERENCES leveranciers(id);
ALTER TABLE ONLY clusters ADD CONSTRAINT clusters_parent_fkey FOREIGN KEY (parent) REFERENCES clusters(id);
ALTER TABLE ONLY functie_items ADD CONSTRAINT functie_items_functie_fkey FOREIGN KEY (functie) REFERENCES thema_functies(id);
ALTER TABLE ONLY onderdeel_medewerkers ADD CONSTRAINT onderdeel_medewerkers_medewerker_fkey FOREIGN KEY (medewerker) REFERENCES medewerkers(id);
ALTER TABLE ONLY onderdeel_medewerkers ADD CONSTRAINT onderdeel_medewerkers_onderdeel_fkey FOREIGN KEY (onderdeel) REFERENCES onderdeel(id);
ALTER TABLE ONLY thema_applicaties ADD CONSTRAINT thema_applicaties_applicatie_fkey FOREIGN KEY (applicatie) REFERENCES applicaties(id);
ALTER TABLE ONLY thema_applicaties ADD CONSTRAINT thema_applicaties_thema_fkey FOREIGN KEY (thema) REFERENCES themas(id);
ALTER TABLE ONLY thema_data ADD CONSTRAINT thema_data_data_type_fkey FOREIGN KEY (data_type) REFERENCES data_typen(id);
ALTER TABLE ONLY thema_data ADD CONSTRAINT thema_data_moscow_fkey FOREIGN KEY (moscow) REFERENCES moscow(id);
ALTER TABLE ONLY thema_data ADD CONSTRAINT thema_data_thema_fkey FOREIGN KEY (thema) REFERENCES themas(id);
ALTER TABLE ONLY thema_data ADD CONSTRAINT thema_data_waarde_type_fkey FOREIGN KEY (waarde_type) REFERENCES waarde_typen(id);
ALTER TABLE ONLY thema_functies ADD CONSTRAINT thema_functies_applicatie_fkey FOREIGN KEY (applicatie) REFERENCES applicaties(id);
ALTER TABLE ONLY thema_functies ADD CONSTRAINT thema_functies_thema_fkey FOREIGN KEY (thema) REFERENCES themas(id);
ALTER TABLE ONLY thema_verantwoordelijkheden ADD CONSTRAINT thema_verantwoordelijkheden_medewerker_fkey FOREIGN KEY (medewerker) REFERENCES medewerkers(id);
ALTER TABLE ONLY thema_verantwoordelijkheden ADD CONSTRAINT thema_verantwoordelijkheden_onderdeel_fkey FOREIGN KEY (onderdeel) REFERENCES onderdeel(id);
ALTER TABLE ONLY thema_verantwoordelijkheden ADD CONSTRAINT thema_verantwoordelijkheden_rol_fkey FOREIGN KEY (rol) REFERENCES rollen(id);
ALTER TABLE ONLY thema_verantwoordelijkheden ADD CONSTRAINT thema_verantwoordelijkheden_thema_fkey FOREIGN KEY (thema) REFERENCES themas(id);
ALTER TABLE ONLY themas ADD CONSTRAINT themas_cluster_fkey FOREIGN KEY ("cluster") REFERENCES clusters(id);
ALTER TABLE ONLY themas ADD CONSTRAINT themas_moscow_fkey FOREIGN KEY (moscow) REFERENCES moscow(id);
ALTER TABLE ONLY workshop_medewerkers ADD CONSTRAINT workshop_medewerkers_medewerker_fkey FOREIGN KEY (medewerker) REFERENCES medewerkers(id);
ALTER TABLE ONLY workshop_medewerkers ADD CONSTRAINT workshop_medewerkers_workshop_fkey FOREIGN KEY (workshop) REFERENCES workshops(id);


COMMENT ON SCHEMA public IS 'Standard public schema';
COMMENT ON COLUMN themas.wms_layers_real IS 'Echte naam van de layer. De waarde in deze kolom wordt ook echt gebruikt voor de LAYERS parameter voor het WMS request. Toegevoegd omdat kaartenbalie niet de originele laagnamen van de WMS server overneemt maar er nummers en underscore voorzet, echter bij elke keer updaten andere nummers.';
COMMENT ON COLUMN themas.wms_querylayers_real IS 'Zie commentaar voor wms_layers_real';
COMMENT ON COLUMN themas.wms_legendlayer_real IS 'Zie commentaar voor wms_layers_real';
CREATE INDEX data_types_pkey ON data_typen USING btree (id);

--
-- TOC entry 2661 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

INSERT INTO moscow (id, code, naam) VALUES ('1','M','Must Have');
INSERT INTO moscow (id, code, naam) VALUES ('2','S','Should Have');
INSERT INTO moscow (id, code, naam) VALUES ('3','C','Could Have');
INSERT INTO moscow (id, code, naam) VALUES ('4','W','Will Not Have');
INSERT INTO moscow (id, code, naam) VALUES ('5','O','Onbekend');

INSERT INTO data_typen (id, naam) VALUES ('1','data');
INSERT INTO data_typen (id, naam) VALUES ('2','url');
INSERT INTO data_typen (id, naam) VALUES ('3','query');

INSERT INTO waarde_typen (id, naam) VALUES ('1','string');
INSERT INTO waarde_typen (id, naam) VALUES ('2','integer');
INSERT INTO waarde_typen (id, naam) VALUES ('3','double');
INSERT INTO waarde_typen (id, naam) VALUES ('4','date');
INSERT INTO waarde_typen (id, naam) VALUES ('5','url');

ALTER TABLE themas ADD COLUMN metadata_link character varying(255);

ALTER TABLE themas ADD COLUMN connectie integer;

CREATE TABLE connecties
(
   id serial, 
   naam character varying(100) NOT NULL, 
   connectie_url character varying(255), 
   gebruikersnaam character varying(50), 
   wachtwoord character varying(50), 
    PRIMARY KEY (id)
) WITHOUT OIDS;

ALTER TABLE themas ADD CONSTRAINT themas_connecties_fkey FOREIGN KEY (connectie) REFERENCES connecties (id)    ON UPDATE NO ACTION ON DELETE NO ACTION;

INSERT INTO data_typen(
            id, naam)
    VALUES (4, 'Javascript functie');

ALTER TABLE themas ADD COLUMN organizationcodekey character varying(50);


REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;