-- ─── TABLE: ScheduleResources ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleResources" (
    ResourceNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    CategoryNo integer NOT NULL,
    Name character varying(100) NOT NULL,
    Enabled boolean NOT NULL,
    Description text NOT NULL,
    BuyGroupNo integer NOT NULL,
    IsRepair boolean NOT NULL,
    IsDisposed boolean NOT NULL,
    IsReservation boolean NOT NULL,
    Type integer,
    IsHidenReg boolean,
    Color character varying(10)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
