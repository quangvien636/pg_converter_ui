-- ─── TABLE: Mail_MailFilters ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailFilters" (
    FilterNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    FieldFg character varying(4) NOT NULL,
    ConditionFg character varying(4) NOT NULL,
    ExecFg character varying(4) NOT NULL,
    ExecValue character varying(500) NOT NULL,
    MailBoxNo bigint NOT NULL,
    SortNo integer NOT NULL,
    PRIMARY KEY (FilterNo, UserNo, SortNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
