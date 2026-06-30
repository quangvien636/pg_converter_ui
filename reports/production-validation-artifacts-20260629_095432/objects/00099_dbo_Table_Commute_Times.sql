-- ─── TABLE: Commute_Times ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Commute_Times" (
    CommuteNo serial NOT NULL,
    UserNo integer,
    CommuteDate character varying(10),
    StartTime character varying(8),
    EndTime character varying(8),
    OTType character varying(10),
    OTStart character varying(50),
    OTEnd character varying(50),
    VacationType character varying(50),
    Vacation character varying(50),
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
