-- ─── TABLE: EDMSAuthFolder ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSAuthFolder" (
    ID serial NOT NULL,
    DivID character(1) NOT NULL,
    FolderID character varying(10) NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
