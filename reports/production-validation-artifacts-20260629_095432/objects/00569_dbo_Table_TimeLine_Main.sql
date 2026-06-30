-- ─── TABLE: TimeLine_Main ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."TimeLine_Main" (
    Seq bigserial NOT NULL,
    Mode integer NOT NULL,
    Title character varying(200) NOT NULL,
    Content text NOT NULL,
    IsEnd character(1) NOT NULL,
    Memo character varying(50) NOT NULL,
    ViewDate timestamp without time zone NOT NULL,
    UserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    LinkUrl character varying(1000) NOT NULL,
    LinkKey character varying(1000) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
