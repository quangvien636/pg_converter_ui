-- ─── TABLE: WorkingTime_Locations ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_Locations" (
    LocationNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    Latitude double precision NOT NULL,
    Longitude double precision NOT NULL,
    ErrorRange integer NOT NULL,
    Description character varying(500) NOT NULL,
    Enabled boolean NOT NULL,
    Description2 character varying(500),
    Representation character varying(100),
    PhoneNumber character varying(100),
    TType integer,
    GType integer,
    uids character varying(1000),
    dids character varying(1000)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
