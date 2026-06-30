-- ─── TABLE: Board_Sharers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_Sharers" (
    ContentNo integer NOT NULL,
    DepartNo integer NOT NULL,
    DepartName character varying(100),
    IsChild character(1),
    UserNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
