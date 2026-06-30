-- ─── TABLE: Contacts_Locations ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Contacts_Locations" (
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
    ContactUserId integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
