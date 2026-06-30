-- ─── TABLE: Schedule_Notifications ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Schedule_Notifications" (
    NotiNo bigserial NOT NULL,
    ScheduleNo integer NOT NULL,
    NotificationType integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
