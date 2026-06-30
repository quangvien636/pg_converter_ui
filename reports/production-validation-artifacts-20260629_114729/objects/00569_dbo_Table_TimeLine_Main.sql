-- ─── TABLE: TimeLine_Main ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."TimeLine_Main" (
    Seq bigserial NOT NULL,
    Mode integer NOT NULL DEFAULT 0,
    Title character varying(200) NOT NULL,
    Content text NOT NULL,
    IsEnd character(1) NOT NULL DEFAULT 'N',
    Memo character varying(50) NOT NULL DEFAULT '',
    ViewDate timestamp without time zone NOT NULL DEFAULT now(),
    UserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    LinkUrl character varying(1000) NOT NULL DEFAULT '',
    LinkKey character varying(1000) NOT NULL DEFAULT ''
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
