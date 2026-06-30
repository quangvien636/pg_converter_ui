-- ─── TABLE: ContactsUserHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsUserHistory" (
    HistoryNo serial NOT NULL,
    Seq integer,
    FirstName character varying(100),
    LastName character varying(100),
    RegUserNo integer,
    Memo character varying(500),
    RegDate timestamp without time zone,
    Photo character varying(500),
    ModDate timestamp without time zone,
    CheckDate timestamp without time zone,
    Share character varying(50),
    UseYn character varying(1),
    DelDate timestamp without time zone,
    Important integer,
    CallName character varying(20),
    ViewCount integer,
    Status character varying(3)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
