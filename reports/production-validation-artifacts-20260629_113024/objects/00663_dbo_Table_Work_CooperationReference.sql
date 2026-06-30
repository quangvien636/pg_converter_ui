-- ─── TABLE: Work_CooperationReference ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Work_CooperationReference" (
    ReferenceNo serial NOT NULL,
    CooperationNo integer,
    UserNo integer,
    ReadDate timestamp without time zone,
    ViewBool boolean
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
