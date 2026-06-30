-- ─── TABLE: WorkingTime_RequestCorrectionTime ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_RequestCorrectionTime" (
    WorkingNo integer NOT NULL PRIMARY KEY,
    RegUserNo integer NOT NULL,
    RegDate datetimeoffset NOT NULL,
    AccUserNo integer NOT NULL,
    AccDate datetimeoffset NOT NULL,
    Status integer,
    Reject integer,
    RejectDate datetimeoffset,
    RejectDes character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
