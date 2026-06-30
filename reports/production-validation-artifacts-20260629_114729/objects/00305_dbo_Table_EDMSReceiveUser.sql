-- ─── TABLE: EDMSReceiveUser ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSReceiveUser" (
    ID serial NOT NULL,
    DOCID integer NOT NULL,
    USERID character varying(50) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
