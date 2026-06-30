-- ─── TABLE: WorkingTime_RequestCorrectionTime ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_RequestCorrectionTime" (
    WorkingNo integer NOT NULL PRIMARY KEY,
    RegUserNo integer NOT NULL,
    RegDate timestamp with time zone NOT NULL,
    AccUserNo integer NOT NULL,
    AccDate timestamp with time zone NOT NULL,
    Status integer DEFAULT 0,
    Reject integer DEFAULT 0,
    RejectDate timestamp with time zone,
    RejectDes character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
