-- ─── TABLE: Mail_SentLogs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_SentLogs" (
    LogNo bigserial NOT NULL,
    MailNo bigint NOT NULL,
    CMSendNum bigint NOT NULL,
    Name character varying(100) NOT NULL,
    Address character varying(100) NOT NULL,
    SentType integer NOT NULL,
    IsComplete boolean NOT NULL,
    IsCancel boolean NOT NULL,
    ReadDate timestamp without time zone,
    DeliveredDate timestamp without time zone,
    PRIMARY KEY (LogNo, MailNo, CMSendNum, Address)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
