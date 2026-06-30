-- ─── TABLE: EDMSDocSubInfo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSDocSubInfo" (
    id serial NOT NULL,
    edmsid integer NOT NULL,
    FormName1 character varying(100),
    FormName2 character varying(100),
    FormName3 character varying(100),
    FormName4 character varying(100)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
