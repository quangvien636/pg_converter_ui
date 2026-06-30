-- ─── TABLE: ScheduleResourcesRepair ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleResourcesRepair" (
    RepairNo serial NOT NULL,
    ResourceNo integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    LastUserNo integer NOT NULL DEFAULT 0,
    CompanyName character varying(200) NOT NULL DEFAULT '',
    Amount numeric(18,0) NOT NULL DEFAULT 0,
    StartDate date NOT NULL DEFAULT '1900-01-01',
    EndDate date NOT NULL DEFAULT '1900-01-01',
    Reason text NOT NULL DEFAULT '',
    Status character varying(1) NOT NULL DEFAULT 'R'
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
