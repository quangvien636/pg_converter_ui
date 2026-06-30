-- ─── TABLE: EAFSM ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAFSM" (
    ID serial NOT NULL,
    FormID integer NOT NULL,
    Name character varying(50) NOT NULL,
    Script text,
    Url character varying(100),
    Flag character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
