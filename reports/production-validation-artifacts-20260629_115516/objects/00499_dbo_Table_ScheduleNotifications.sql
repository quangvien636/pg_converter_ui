-- ─── TABLE: ScheduleNotifications ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleNotifications" (
    NotificationNo serial NOT NULL,
    ScheduleNo integer NOT NULL,
    NotificationType character varying(100),
    AlarmTime integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
