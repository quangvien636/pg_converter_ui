-- ─── TABLE: Board_Managers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_Managers" (
    UserNo integer NOT NULL,
    BoardNo integer NOT NULL,
    Auth integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
