-- ─── TABLE: SurveyAttachments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SurveyAttachments" (
    AttachNo serial NOT NULL,
    SurveyNo integer NOT NULL,
    FileName character varying(260) NOT NULL,
    FileLength integer NOT NULL,
    FilePath character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
