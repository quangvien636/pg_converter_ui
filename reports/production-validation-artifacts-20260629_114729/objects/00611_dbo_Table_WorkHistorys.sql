-- ─── TABLE: WorkHistorys ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkHistorys" (
    HistoryNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    WorkNo integer NOT NULL,
    Title character varying(100) NOT NULL,
    UserNo integer NOT NULL,
    DivisionNo integer NOT NULL,
    WorkTime integer NOT NULL,
    CompleteDate date NOT NULL,
    IsEveryPerson boolean NOT NULL,
    Content character varying(3000) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
