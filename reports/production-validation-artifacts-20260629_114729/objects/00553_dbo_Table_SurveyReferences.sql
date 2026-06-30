-- ─── TABLE: SurveyReferences ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SurveyReferences" (
    ReferenceNo serial NOT NULL,
    SurveyNo integer NOT NULL,
    Poll character(1) NOT NULL,
    UserNo integer NOT NULL,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
