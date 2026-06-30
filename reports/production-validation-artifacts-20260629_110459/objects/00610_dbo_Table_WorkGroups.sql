-- ─── TABLE: WorkGroups ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkGroups" (
    GroupNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    HistoryNo integer NOT NULL,
    IsLock boolean NOT NULL,
    State integer NOT NULL,
    FinalDate date,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
