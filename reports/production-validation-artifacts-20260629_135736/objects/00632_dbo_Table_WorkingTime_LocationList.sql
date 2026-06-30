-- ─── TABLE: WorkingTime_LocationList ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_LocationList" (
    id serial NOT NULL,
    name character varying(250),
    dayadd integer,
    timeadd character varying(250),
    distance double precision,
    lat double precision,
    lng double precision,
    userno integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
