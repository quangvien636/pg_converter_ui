-- ─── TABLE: Center_NotificationService_AlarmDetail_Execution ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_NotificationService_AlarmDetail_Execution" (
    NotificationService_AlarmDetail_Execution bigserial NOT NULL,
    NotificationNo bigint NOT NULL,
    NotificationService_AlarmDetailNo bigint NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ExecutionDate date NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
