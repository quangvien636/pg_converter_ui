-- ─── TABLE: Mail_Mails_Mapping ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_Mails_Mapping" (
    MailType character varying(1) NOT NULL,
    SeqNo integer NOT NULL,
    UserNo integer NOT NULL,
    MailNo integer,
    PRIMARY KEY (MailType, SeqNo, UserNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
