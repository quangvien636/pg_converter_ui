-- ─── TABLE: WorkingTime_BeaconPoints ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_BeaconPoints" (
    PointNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    LocationNo integer NOT NULL,
    BeaconUUID character varying(36) NOT NULL,
    BeaconMajor integer NOT NULL,
    BeaconMinor integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
