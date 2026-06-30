-- ─── TABLE: TimeLine_Share ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."TimeLine_Share" (
    Seq bigint NOT NULL,
    UserId character varying(20) NOT NULL DEFAULT '',
    DepartId character varying(20) NOT NULL DEFAULT ''
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
