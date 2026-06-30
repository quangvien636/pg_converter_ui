-- ─── TABLE: ScheduleResourceNotifications ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleResourceNotifications" (
    NotificationNo serial NOT NULL,
    ResourceNo integer NOT NULL,
    NotificationType character varying(100),
    AlarmTime integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
