-- ─── TABLE: EAPPPath ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPPath" (
    ID serial NOT NULL,
    UserID character varying(50),
    Name character varying(200),
    Hit integer,
    RegDate timestamp without time zone,
    ModDate timestamp without time zone,
    IsDelete character(1),
    Description character varying(500),
    IsInReceive character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
