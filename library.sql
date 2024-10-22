--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pgsql
--

COMMENT ON SCHEMA public IS 'Standard public schema';


--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: pgsql
--

CREATE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- Name: check_before_order_insert(); Type: FUNCTION; Schema: public; Owner: xeraoo
--

CREATE FUNCTION check_before_order_insert() RETURNS "trigger"
    AS $$BEGIN
IF (SELECT is_available FROM books WHERE book_id = NEW.book_id) <> 'Y' OR (SELECT how_many FROM users WHERE user_id = NEW.user_id) >=10 THEN
RAISE NOTICE 'ksiazka niedostepna lub uzytkownik osiagnal limit 10 wypozyczonych ksiazek jednoczesnie';
RETURN NULL;
ELSE
RETURN NEW;
END IF;
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.check_before_order_insert() OWNER TO xeraoo;

--
-- Name: check_before_order_update(); Type: FUNCTION; Schema: public; Owner: xeraoo
--

CREATE FUNCTION check_before_order_update() RETURNS "trigger"
    AS $$BEGIN
IF OLD.was_prolonged = 'N' THEN
RETURN NEW;
ELSE
RAISE NOTICE 'ksiazka byla juz prolongowana';
RETURN NULL;
END IF;
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.check_before_order_update() OWNER TO xeraoo;

--
-- Name: update_after_order_delete(); Type: FUNCTION; Schema: public; Owner: xeraoo
--

CREATE FUNCTION update_after_order_delete() RETURNS "trigger"
    AS $$
BEGIN
UPDATE users SET how_many = how_many - 1 WHERE user_id = OLD.user_id;
UPDATE books SET is_available = 'Y' WHERE book_id = OLD.book_id;
RETURN NULL;
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.update_after_order_delete() OWNER TO xeraoo;

--
-- Name: update_after_order_insert(); Type: FUNCTION; Schema: public; Owner: xeraoo
--

CREATE FUNCTION update_after_order_insert() RETURNS "trigger"
    AS $$
BEGIN
UPDATE users SET how_many = how_many + 1 WHERE user_id = NEW.user_id;
UPDATE books SET is_available = 'N' WHERE book_id = NEW.book_id;
RETURN NULL;
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.update_after_order_insert() OWNER TO xeraoo;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: books; Type: TABLE; Schema: public; Owner: xeraoo; Tablespace: 
--

CREATE TABLE books (
    book_id integer NOT NULL,
    title character varying(50) NOT NULL,
    author_name character varying(20) NOT NULL,
    author_surname character varying(20) NOT NULL,
    "year" integer NOT NULL,
    is_available character(1) NOT NULL,
    days integer NOT NULL
);


ALTER TABLE public.books OWNER TO xeraoo;

--
-- Name: books_book_id_seq; Type: SEQUENCE; Schema: public; Owner: xeraoo
--

CREATE SEQUENCE books_book_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.books_book_id_seq OWNER TO xeraoo;

--
-- Name: books_book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xeraoo
--

ALTER SEQUENCE books_book_id_seq OWNED BY books.book_id;


--
-- Name: books_book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xeraoo
--

SELECT pg_catalog.setval('books_book_id_seq', 13, true);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: xeraoo; Tablespace: 
--

CREATE TABLE orders (
    order_id integer NOT NULL,
    user_id integer,
    book_id integer,
    is_reserved character(1) NOT NULL,
    was_prolonged character(1) NOT NULL,
    order_date date,
    return_date date
);


ALTER TABLE public.orders OWNER TO xeraoo;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: xeraoo
--

CREATE SEQUENCE orders_order_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.orders_order_id_seq OWNER TO xeraoo;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xeraoo
--

ALTER SEQUENCE orders_order_id_seq OWNED BY orders.order_id;


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xeraoo
--

SELECT pg_catalog.setval('orders_order_id_seq', 59, true);


--
-- Name: user_id; Type: SEQUENCE; Schema: public; Owner: xeraoo
--

CREATE SEQUENCE user_id
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user_id OWNER TO xeraoo;

--
-- Name: user_id; Type: SEQUENCE SET; Schema: public; Owner: xeraoo
--

SELECT pg_catalog.setval('user_id', 1004, true);


--
-- Name: users; Type: TABLE; Schema: public; Owner: xeraoo; Tablespace: 
--

CREATE TABLE users (
    user_id integer NOT NULL,
    name character varying(20) NOT NULL,
    surname character varying(20) NOT NULL,
    "password" character varying(32) NOT NULL,
    how_many integer NOT NULL,
    who character(1) NOT NULL,
    email character varying(30)
);


ALTER TABLE public.users OWNER TO xeraoo;

--
-- Name: book_id; Type: DEFAULT; Schema: public; Owner: xeraoo
--

ALTER TABLE books ALTER COLUMN book_id SET DEFAULT nextval('books_book_id_seq'::regclass);


--
-- Name: order_id; Type: DEFAULT; Schema: public; Owner: xeraoo
--

ALTER TABLE orders ALTER COLUMN order_id SET DEFAULT nextval('orders_order_id_seq'::regclass);


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: xeraoo
--

COPY books (book_id, title, author_name, author_surname, "year", is_available, days) FROM stdin;
7	Kod Da Vinci	Dan	Brown	2003	Y	30
13	Janko Muzykant	Henryk	Sienkiewicz	1990	N	30
2	Systemy komutacji	Andrzej	Jajszczyk	2002	N	30
11	Przygody Sherlocka Holmesa	Artur Conan	Doyle	1956	N	30
5	Pan Wolodyjowski	Henryk	Sienkiewicz	1990	N	30
1	Pan Tadeusz	Adam	Mickiewicz	1956	N	30
6	Ojciec chrzestny	Mario	Puzo	1980	N	30
3	Ogniem i mieczem	Henryk	Sienkiewicz	1990	N	30
8	Robinson Crusoe	Daniel	Defoe	1960	N	30
12	Analiza matematyczna w zadaniach cz. 1	Wlodzimierz	Krysicki	2002	N	30
9	Hrabia Monte Christo	Aleksander	Dumas	1975	N	30
10	SQL	Martin	Gruber	1996	N	30
4	Potop	Henryk	Sienkiewicz	1990	N	30
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: xeraoo
--

COPY orders (order_id, user_id, book_id, is_reserved, was_prolonged, order_date, return_date) FROM stdin;
27	1003	4	N	Y	2008-05-18	2008-07-17
34	1003	3	N	N	2008-05-18	2008-06-17
35	1003	8	N	N	2008-05-18	2008-06-17
46	1003	12	N	N	2008-05-18	2008-06-17
55	1004	9	N	N	2008-05-18	2008-06-17
56	1002	10	N	N	2008-05-18	2008-06-17
57	1002	4	N	N	2008-05-18	2008-06-17
30	1003	5	N	N	2008-05-18	2008-06-17
31	1003	1	N	N	2008-05-18	2008-06-17
28	1003	2	N	Y	2008-05-18	2008-07-17
32	1003	6	N	Y	2008-05-18	2008-07-17
29	1003	11	N	Y	2008-05-18	2008-07-17
59	1003	13	N	Y	2008-05-25	2008-07-24
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: xeraoo
--

COPY users (user_id, name, surname, "password", how_many, who, email) FROM stdin;
1003	user2	c	098f6bcd4621d373cade4e832627b4f6	10	u	sa@elo.com
1001	daik	b	098f6bcd4621d373cade4e832627b4f6	0	tk@student.agh.edu.pl
1000	xeraoo	b	b0adc76e043a5ad75b5cf68aabedcafc	0	a	ma@op.pl
1004	user3	d	098f6bcd4621d373cade4e832627b4f6	1	u	zm@dpa.com
1002	user1	a	098f6bcd4621d373cade4e832627b4f6	2	u	kr@kt.agh.edu.pl
\.


--
-- Name: books_pkey; Type: CONSTRAINT; Schema: public; Owner: xeraoo; Tablespace: 
--

ALTER TABLE ONLY books
    ADD CONSTRAINT books_pkey PRIMARY KEY (book_id);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: xeraoo; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: unique_book; Type: CONSTRAINT; Schema: public; Owner: xeraoo; Tablespace: 
--

ALTER TABLE ONLY books
    ADD CONSTRAINT unique_book UNIQUE (title, author_name, author_surname, "year");


--
-- Name: unique_order; Type: CONSTRAINT; Schema: public; Owner: xeraoo; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT unique_order UNIQUE (user_id, book_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: xeraoo; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: trig_check_before_order_insert; Type: TRIGGER; Schema: public; Owner: xeraoo
--

CREATE TRIGGER trig_check_before_order_insert
    BEFORE INSERT ON orders
    FOR EACH ROW
    EXECUTE PROCEDURE check_before_order_insert();


--
-- Name: trig_check_before_order_update; Type: TRIGGER; Schema: public; Owner: xeraoo
--

CREATE TRIGGER trig_check_before_order_update
    BEFORE UPDATE ON orders
    FOR EACH ROW
    EXECUTE PROCEDURE check_before_order_update();


--
-- Name: trig_update_after_order_delete; Type: TRIGGER; Schema: public; Owner: xeraoo
--

CREATE TRIGGER trig_update_after_order_delete
    AFTER DELETE ON orders
    FOR EACH ROW
    EXECUTE PROCEDURE update_after_order_delete();


--
-- Name: trig_update_after_order_insert; Type: TRIGGER; Schema: public; Owner: xeraoo
--

CREATE TRIGGER trig_update_after_order_insert
    AFTER INSERT ON orders
    FOR EACH ROW
    EXECUTE PROCEDURE update_after_order_insert();


--
-- Name: orders_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xeraoo
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_book_id_fkey FOREIGN KEY (book_id) REFERENCES books(book_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xeraoo
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: pgsql
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM pgsql;
GRANT ALL ON SCHEMA public TO pgsql;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

