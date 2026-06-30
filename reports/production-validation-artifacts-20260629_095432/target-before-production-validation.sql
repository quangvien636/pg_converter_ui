--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.17
-- Dumped by pg_dump version 9.5.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: fn_userlabel(character varying, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_userlabel(name character varying, isactive boolean) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN

    RETURN COALESCE(Name, '') || CASE WHEN IsActive = TRUE THEN ' Active' ELSE ' Inactive' END;
END;
$$;


--
-- Name: fn_userorders(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_userorders(userid integer) RETURNS TABLE(orderid integer, amount numeric)
    LANGUAGE plpgsql
    AS $$
#variable_conflict use_column
BEGIN

    RETURN QUERY SELECT OrderId, Amount FROM public."Orders" WHERE UserId = fn_userorders.userid;
END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "Orders" (
    orderid integer NOT NULL,
    userid integer NOT NULL,
    amount numeric(18,2) NOT NULL
);


--
-- Name: Orders_orderid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "Orders_orderid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Orders_orderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "Orders_orderid_seq" OWNED BY "Orders".orderid;


--
-- Name: Users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "Users" (
    id integer NOT NULL,
    tenantid bigint NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    name character varying(100) NOT NULL,
    bio text,
    createdat timestamp without time zone DEFAULT now() NOT NULL,
    guid uuid NOT NULL,
    balance numeric(19,4) DEFAULT 0 NOT NULL,
    payload bytea
);


--
-- Name: Users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "Users_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "Users_id_seq" OWNED BY "Users".id;


--
-- Name: orderid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Orders" ALTER COLUMN orderid SET DEFAULT nextval('"Orders_orderid_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Users" ALTER COLUMN id SET DEFAULT nextval('"Users_id_seq"'::regclass);


--
-- Data for Name: Orders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "Orders" (orderid, userid, amount) FROM stdin;
1	1	25.50
\.


--
-- Name: Orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"Orders_orderid_seq"', 1, true);


--
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "Users" (id, tenantid, isactive, name, bio, createdat, guid, balance, payload) FROM stdin;
1	1	t	QA	\N	2026-06-29 11:45:47.426	00000000-0000-0000-0000-000000000001	0.0000	\N
\.


--
-- Name: Users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"Users_id_seq"', 1, true);


--
-- Name: Orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Orders"
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (orderid);


--
-- Name: Users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: cx_users_tenant; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cx_users_tenant ON "Users" USING btree (tenantid);


--
-- Name: ix_orders_user_amount; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_orders_user_amount ON "Orders" USING btree (userid, amount);


--
-- Name: ix_orders_user_include; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_orders_user_include ON "Orders" USING btree (userid);


--
-- Name: ix_users_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_users_active ON "Users" USING btree (isactive);


--
-- Name: ix_users_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_users_name ON "Users" USING btree (name);


--
-- Name: ux_users_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_users_guid ON "Users" USING btree (guid);


--
-- Name: fk_orders_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Orders"
    ADD CONSTRAINT fk_orders_users FOREIGN KEY (userid) REFERENCES "Users"(id);


--
-- PostgreSQL database dump complete
--

