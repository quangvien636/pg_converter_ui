-- ─── TABLE: ScheduleResourcesRepair ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleResourcesRepair" (
    RepairNo serial NOT NULL,
    ResourceNo integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    LastUserNo integer NOT NULL,
    CompanyName character varying(200) NOT NULL,
    Amount numeric(18,0) NOT NULL,
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    Reason text NOT NULL,
    Status character varying(1) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
