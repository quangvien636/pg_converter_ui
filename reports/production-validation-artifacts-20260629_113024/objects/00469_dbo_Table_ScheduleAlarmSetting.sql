-- ─── TABLE: ScheduleAlarmSetting ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleAlarmSetting" (
    UserNo integer NOT NULL PRIMARY KEY,
    IsEmail boolean,
    IsAlarmi boolean,
    IsPC boolean,
    IsMobile boolean,
    TimeAlarm integer,
    IsUnuse boolean,
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModDate timestamp without time zone,
    IsWebAlarm boolean
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
