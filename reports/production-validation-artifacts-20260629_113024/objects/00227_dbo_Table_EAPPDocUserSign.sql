-- ─── TABLE: EAPPDocUserSign ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPDocUserSign" (
    DocID integer NOT NULL,
    UserID character varying(20) NOT NULL,
    PID integer NOT NULL,
    Sign character varying(30) NOT NULL,
    PRIMARY KEY (DocID, PID)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
