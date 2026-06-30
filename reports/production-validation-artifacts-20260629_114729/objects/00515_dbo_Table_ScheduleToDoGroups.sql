-- ─── TABLE: ScheduleToDoGroups ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleToDoGroups" (
    GroupNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
