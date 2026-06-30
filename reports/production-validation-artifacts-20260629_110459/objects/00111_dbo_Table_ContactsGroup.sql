-- ─── TABLE: ContactsGroup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsGroup" (
    GroupNo serial NOT NULL,
    GroupName text,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    Memo character varying(500) DEFAULT '',
    ParentGNo integer NOT NULL,
    Sort integer NOT NULL DEFAULT 1,
    IsDefault character(1) NOT NULL DEFAULT 0,
    UseYn character(1) DEFAULT 'Y'
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
