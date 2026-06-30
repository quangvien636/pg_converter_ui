-- ─── TABLE: WorkingTime_LocationsOutside ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_LocationsOutside" (
    LocationNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    Latitude character varying(20) NOT NULL,
    Longitude character varying(20) NOT NULL,
    ErrorRange integer NOT NULL,
    Representation character varying(100),
    PhoneNumber character varying(100),
    Description character varying(500) NOT NULL,
    Enabled boolean NOT NULL DEFAULT true,
    Description2 character varying(500),
    TType integer,
    GType integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
