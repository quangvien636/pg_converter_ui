-- ─── TABLE: WorkingTime_Images ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_Images" (
    ImageNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    DateUpload timestamp without time zone NOT NULL,
    UrlImage character varying(500) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
