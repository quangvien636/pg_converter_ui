-- ─── TABLE: Contact_PublicGroup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Contact_PublicGroup" (
    PublicGroupNo serial NOT NULL,
    PublicGroupName text,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL DEFAULT now(),
    ParentNo integer NOT NULL,
    Sort integer NOT NULL,
    IsDelete boolean NOT NULL DEFAULT 'FALSE'
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
