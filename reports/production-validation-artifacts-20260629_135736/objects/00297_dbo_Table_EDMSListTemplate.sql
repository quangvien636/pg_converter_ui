-- ─── TABLE: EDMSListTemplate ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSListTemplate" (
    ID serial NOT NULL,
    UserID character varying(50),
    ListID character varying(50),
    Template character varying(200)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
