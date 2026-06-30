-- ─── TABLE: CrewChat_Versions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_Versions" (
    PCVersion character varying(50) NOT NULL,
    AndroidVersion character varying(50) NOT NULL,
    iOSVersion character varying(50) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
