-- ─── TABLE: DDay_CompletedRecords ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DDay_CompletedRecords" (
    RecordNo bigserial NOT NULL,
    DayNo bigint NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    CompletedDate date NOT NULL,
    Comment text NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
