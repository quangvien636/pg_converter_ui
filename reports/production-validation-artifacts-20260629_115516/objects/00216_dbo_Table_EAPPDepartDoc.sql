-- ─── TABLE: EAPPDepartDoc ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPDepartDoc" (
    ID serial NOT NULL,
    DepartID character varying(50),
    FolderID integer,
    DocID integer,
    MoveDate timestamp without time zone,
    Description character varying(1000)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
