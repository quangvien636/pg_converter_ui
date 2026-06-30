-- ─── TABLE: WorkingTimeV2_Times ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTimeV2_Times" (
    V2No serial NOT NULL,
    UserNo integer NOT NULL,
    UseriD character varying(20) NOT NULL,
    WORKDAY integer,
    RegDate timestamp without time zone NOT NULL,
    CheckIn timestamp without time zone,
    CheckOut timestamp without time zone,
    CheckIne timestamp without time zone,
    CheckOute timestamp without time zone,
    TypeNo integer,
    TYPENAME character varying(200)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
