-- ─── TABLE: Mail_MailBoxs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailBoxs" (
    BoxNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    Name character varying(50) NOT NULL,
    ParentNo bigint NOT NULL,
    SortNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    TotalCount integer NOT NULL,
    UnReadCount integer NOT NULL,
    IsShare boolean NOT NULL,
    PRIMARY KEY (BoxNo, UserNo, SortNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
