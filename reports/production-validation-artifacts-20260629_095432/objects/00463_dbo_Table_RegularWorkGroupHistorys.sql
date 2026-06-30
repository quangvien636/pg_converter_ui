-- ─── TABLE: RegularWorkGroupHistorys ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."RegularWorkGroupHistorys" (
    HistoryNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    GroupNo integer NOT NULL,
    Name character varying(100) NOT NULL,
    DivisionNo integer NOT NULL,
    UserNo integer NOT NULL,
    IsEveryPerson boolean NOT NULL,
    Content character varying(3000) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
