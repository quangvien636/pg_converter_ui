-- ─── TABLE: Mail_MailReceivedStatistics ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailReceivedStatistics" (
    StatisticsNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    AccNo bigint NOT NULL,
    ReceivedDate date NOT NULL,
    NormalCount integer NOT NULL,
    SpamCount integer NOT NULL,
    PRIMARY KEY (StatisticsNo, UserNo, AccNo, ReceivedDate)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
