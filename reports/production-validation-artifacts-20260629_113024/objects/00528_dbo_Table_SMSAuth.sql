-- ─── TABLE: SMSAuth ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SMSAuth" (
    UserNo integer NOT NULL PRIMARY KEY,
    SMSAuth character(1),
    LMSAuth character(1),
    LogAuth character(1),
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
