-- ─── TABLE: WorkingTime_Logs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_Logs" (
    DataNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    CheckDate date NOT NULL,
    CheckTime character varying(50) NOT NULL,
    Latitude double precision NOT NULL,
    Longitude double precision NOT NULL,
    Distance character varying(50) NOT NULL,
    EnterOrExit character varying(50)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
