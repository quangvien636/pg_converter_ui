-- ─── TABLE: RegularWorkGroups ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."RegularWorkGroups" (
    GroupNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    HistoryNo integer NOT NULL,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
