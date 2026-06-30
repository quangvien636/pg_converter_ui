-- ─── TABLE: Center_OpenAI ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_OpenAI" (
    No bigserial NOT NULL,
    UserNo integer NOT NULL,
    Type integer NOT NULL,
    Messages text NOT NULL,
    Date timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
