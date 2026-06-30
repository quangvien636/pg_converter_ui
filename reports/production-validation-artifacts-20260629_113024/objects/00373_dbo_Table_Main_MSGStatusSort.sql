-- ─── TABLE: Main_MSGStatusSort ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Main_MSGStatusSort" (
    Seq serial NOT NULL,
    UserId character varying(50) NOT NULL,
    Sort integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
