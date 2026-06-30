-- ─── TABLE: Contact_DepartAllowAccess ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Contact_DepartAllowAccess" (
    AllowAccessNo serial NOT NULL,
    DepartNo integer NOT NULL,
    AllowValue integer NOT NULL,
    ItemNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    RegUserNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
