-- ─── TABLE: Mail_RecentMailFiles ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_RecentMailFiles" (
    RecentNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    MailNo bigint NOT NULL,
    FileNo bigint NOT NULL,
    Name character varying(260) NOT NULL,
    Size integer NOT NULL,
    ActionDate timestamp without time zone NOT NULL,
    PRIMARY KEY (RecentNo, UserNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
