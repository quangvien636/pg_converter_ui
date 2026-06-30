-- ─── TABLE: ScheduleResourcesDispose ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleResourcesDispose" (
    DisposeNo serial NOT NULL,
    ResourceNo integer NOT NULL,
    DisposeDate date NOT NULL,
    DisposeReason text NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
