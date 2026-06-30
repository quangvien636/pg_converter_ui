-- ─── TABLE: DDay_Notifications ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DDay_Notifications" (
    NotiNo bigserial NOT NULL,
    DayNo bigint NOT NULL,
    NotificationType integer NOT NULL,
    NotificationTime time without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
