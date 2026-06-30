-- ─── TABLE: ContactsDays ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsDays" (
    Seq serial NOT NULL,
    RegUserNo integer,
    UserSeq integer,
    Type smallint,
    TypeName character varying(50),
    Value character varying(50),
    IsDefault character(1),
    SolarLunar character(1),
    RegDate timestamp without time zone,
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
