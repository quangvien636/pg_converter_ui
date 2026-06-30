-- ─── TABLE: Mail_UserSettings ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_UserSettings" (
    UserNo integer NOT NULL PRIMARY KEY,
    StartMailBoxNo bigint NOT NULL,
    IsFolderExpanded boolean NOT NULL,
    PagePerCount integer NOT NULL,
    IsTitleOneLine boolean NOT NULL,
    IsAsNameAddress boolean NOT NULL,
    IsConversationList boolean NOT NULL,
    IsAddressAreaExpanded boolean NOT NULL,
    IsIncludedReference integer NOT NULL,
    UseSign boolean NOT NULL,
    MailBoxSize bigint NOT NULL,
    CurrentMailBoxSize bigint NOT NULL,
    AutoSavingTime integer NOT NULL,
    MailBoxLimit bigint,
    OpenMailBoxs text NOT NULL,
    IsNotSavingSentMail boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
