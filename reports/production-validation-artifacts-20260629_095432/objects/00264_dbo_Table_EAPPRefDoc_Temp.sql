-- ─── TABLE: EAPPRefDoc_Temp ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPRefDoc_Temp" (
    ID serial NOT NULL,
    SessionID character varying(32),
    SessionKey character varying(20),
    DocID integer,
    RefDocID integer,
    ReporterID character varying(50),
    Title character varying(512),
    ReportNum integer,
    IsOld character(1),
    RefEdmsId integer,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
