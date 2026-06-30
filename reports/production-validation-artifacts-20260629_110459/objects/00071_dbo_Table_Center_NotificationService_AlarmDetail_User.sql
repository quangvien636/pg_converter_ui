-- ─── TABLE: Center_NotificationService_AlarmDetail_User ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_NotificationService_AlarmDetail_User" (
    NotificationService_AlarmDetail_User bigserial NOT NULL,
    NotificationNo bigint NOT NULL,
    NotificationService_AlarmDetailNo bigint NOT NULL,
    UserNo integer NOT NULL,
    Message character varying(1000) NOT NULL,
    State boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
