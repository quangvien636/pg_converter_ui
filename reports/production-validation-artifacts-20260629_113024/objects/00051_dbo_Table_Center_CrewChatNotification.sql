-- ─── TABLE: Center_CrewChatNotification ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_CrewChatNotification" (
    No bigserial NOT NULL,
    UserNo integer NOT NULL,
    Message text NOT NULL,
    RegDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
