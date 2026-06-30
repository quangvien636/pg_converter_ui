-- ─── TABLE: Mail_Accounts_Delete ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_Accounts_Delete" (
    AccountNo bigint NOT NULL,
    UserNo integer NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Server character varying(100) NOT NULL,
    Port integer NOT NULL,
    PopUser character varying(50) NOT NULL,
    PopPwd character varying(50) NOT NULL,
    IsServerAccount boolean NOT NULL,
    IsSharedAccount boolean NOT NULL,
    IsDeleteEmlFile boolean NOT NULL,
    IsWebMail boolean NOT NULL,
    Name character varying(100) NOT NULL,
    MailAddress character varying(200) NOT NULL,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
