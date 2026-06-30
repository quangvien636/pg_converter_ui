-- ─── TABLE: EDMSTreeAuthority ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSTreeAuthority" (
    id serial NOT NULL,
    DivID character varying(20),
    FolderID character varying(100),
    DepartID character varying(50),
    Authorityflag character(1),
    writer character varying(50),
    Regdate timestamp without time zone,
    Modifier character varying(50),
    Moddate timestamp without time zone,
    ParentId integer NOT NULL DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
