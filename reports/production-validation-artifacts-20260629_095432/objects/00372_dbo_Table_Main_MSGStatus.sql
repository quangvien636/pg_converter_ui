-- ─── TABLE: Main_MSGStatus ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Main_MSGStatus" (
    UserId character varying(50) NOT NULL,
    State integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
