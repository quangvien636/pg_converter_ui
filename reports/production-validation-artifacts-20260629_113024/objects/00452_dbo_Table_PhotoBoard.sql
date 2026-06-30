-- ─── TABLE: PhotoBoard ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."PhotoBoard" (
    ID serial NOT NULL,
    Title character varying(500),
    Content text,
    WriterID character varying(50),
    PositionID character varying(50),
    DepartID character varying(50),
    WOrder integer,
    WLevel integer,
    WGroup integer,
    Hit integer,
    RegDate timestamp without time zone,
    ModDate timestamp without time zone,
    TextContent text
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
