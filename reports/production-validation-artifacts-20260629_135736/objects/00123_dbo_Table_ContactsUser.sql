-- ─── TABLE: ContactsUser ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsUser" (
    Seq serial NOT NULL,
    FirstName character varying(100),
    LastName character varying(100),
    RegUserNo integer,
    Memo character varying(500),
    RegDate timestamp without time zone DEFAULT now(),
    Photo character varying(500),
    ModDate timestamp without time zone,
    CheckDate timestamp without time zone,
    Share character varying(50),
    UseYn character varying(1),
    DelDate timestamp without time zone,
    Important integer,
    CallName character varying(20),
    ViewCount integer NOT NULL DEFAULT 0,
    GroupList character varying(250)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
