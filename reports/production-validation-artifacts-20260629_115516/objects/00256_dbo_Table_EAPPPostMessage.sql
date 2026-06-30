-- ─── TABLE: EAPPPostMessage ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPPostMessage" (
    ID serial NOT NULL,
    Category character(4),
    Code integer,
    UserID character varying(50),
    Type character(1),
    X integer,
    Y integer,
    Width integer,
    Height integer,
    Message text,
    IsAlways character(1),
    IsExpand character(1),
    Authority integer,
    SubAuth integer,
    RegDate timestamp without time zone,
    IsDelete character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
