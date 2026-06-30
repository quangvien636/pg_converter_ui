-- ─── TABLE: EDMSPrivateDoc ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSPrivateDoc" (
    ID serial NOT NULL,
    UserID character varying(50),
    FolderID character varying(100),
    DocID integer,
    MoveDate timestamp without time zone,
    Description character varying(1000)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
