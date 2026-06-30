-- ─── TABLE: Contact_ShareGroupUser ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Contact_ShareGroupUser" (
    No serial NOT NULL,
    ShareGroupNo integer NOT NULL,
    UserSeq integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    IsDelete boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
