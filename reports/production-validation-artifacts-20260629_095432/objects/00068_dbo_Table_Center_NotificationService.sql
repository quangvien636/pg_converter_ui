-- ─── TABLE: Center_NotificationService ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_NotificationService" (
    NotificationNo bigserial NOT NULL,
    CompanyNo integer NOT NULL,
    ProjectCode character varying(100) NOT NULL,
    Connectionkey integer NOT NULL,
    SendUserNo integer NOT NULL,
    RecipientUserNo text NOT NULL,
    RecipientDepartNo text NOT NULL,
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    RepeatType character varying(50) NOT NULL,
    RepeatOptions character varying(500) NOT NULL,
    State boolean,
    Execution timestamp without time zone,
    RegDate timestamp without time zone,
    CrewChatRoomNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
