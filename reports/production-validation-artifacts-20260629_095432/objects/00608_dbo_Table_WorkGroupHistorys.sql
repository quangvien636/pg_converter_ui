-- ─── TABLE: WorkGroupHistorys ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkGroupHistorys" (
    HistoryNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    GroupNo integer NOT NULL,
    Name character varying(100) NOT NULL,
    UserNo integer NOT NULL,
    Content character varying(3000) NOT NULL,
    CompleteDate date NOT NULL,
    StartDate date NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
