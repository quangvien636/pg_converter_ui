-- ─── TABLE: Mail_MailBoxSharers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailBoxSharers" (
    BoxNo bigint NOT NULL,
    RegUserNo integer NOT NULL,
    UserNo integer NOT NULL,
    PositionNo integer NOT NULL,
    DepartNo integer NOT NULL,
    Permission integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
