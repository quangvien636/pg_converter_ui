-- ─── TABLE: Center_NotificationService_AlarmDetail ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_NotificationService_AlarmDetail" (
    NotificationService_AlarmDetailNo bigserial NOT NULL,
    NotificationNo bigint NOT NULL,
    AlarmCode character varying(100) NOT NULL,
    AlarmStartTime time without time zone NOT NULL,
    Alarm_Time integer NOT NULL,
    Title character varying(100) NOT NULL,
    Content_Json text NOT NULL,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
