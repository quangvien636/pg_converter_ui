-- ─── TABLE: Contact_PublicGroupUser ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Contact_PublicGroupUser" (
    No serial NOT NULL,
    PublicGroupNo integer NOT NULL,
    UserSeq integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL DEFAULT now(),
    IsDelete boolean NOT NULL DEFAULT 'FALSE'
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
