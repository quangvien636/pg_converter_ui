-- ─── TABLE: EAPPFile ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPFile" (
    ID serial NOT NULL,
    DocID integer,
    ShowName character varying(500),
    RealName character varying(500),
    ContentID integer,
    Length bigint,
    Sortno integer,
    OpYn character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
