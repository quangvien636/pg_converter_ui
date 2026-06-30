-- ─── TABLE: EDMSReceiveOrg ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSReceiveOrg" (
    ID serial NOT NULL,
    DOCID integer NOT NULL,
    ORGCD character varying(4) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
