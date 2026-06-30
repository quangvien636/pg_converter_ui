-- ─── TABLE: EDMSDocFolder ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSDocFolder" (
    ID serial NOT NULL,
    DocID integer,
    FolderID character varying(100),
    divid character varying(10)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
