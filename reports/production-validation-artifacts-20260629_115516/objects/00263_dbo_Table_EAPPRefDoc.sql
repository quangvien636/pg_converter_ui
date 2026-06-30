-- ─── TABLE: EAPPRefDoc ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPRefDoc" (
    ID serial NOT NULL,
    DocID integer,
    RefDocID integer,
    ReporterID character varying(50),
    ReportNum integer,
    IsOld character(1),
    RefEdmsId integer,
    IsLink character(1) NOT NULL DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
