-- ─── TABLE: ContactsGroup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsGroup" (
    GroupNo serial NOT NULL,
    GroupName text,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    Memo character varying(500),
    ParentGNo integer NOT NULL,
    Sort integer NOT NULL,
    IsDefault character(1) NOT NULL,
    UseYn character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
