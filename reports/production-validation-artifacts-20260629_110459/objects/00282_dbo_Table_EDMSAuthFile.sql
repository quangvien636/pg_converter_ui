-- ─── TABLE: EDMSAuthFile ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSAuthFile" (
    ID serial NOT NULL,
    DivID character(1) NOT NULL,
    FolderID character varying(10) NOT NULL,
    UserNo integer NOT NULL,
    DepartNo integer NOT NULL,
    IsView character(1) NOT NULL,
    IsDownload character(1) NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
