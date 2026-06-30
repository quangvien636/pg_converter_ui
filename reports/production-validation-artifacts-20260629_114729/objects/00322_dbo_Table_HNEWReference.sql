-- ─── TABLE: HNEWReference ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."HNEWReference" (
    DocID integer NOT NULL,
    UserID character varying(50) NOT NULL,
    ReadDate character varying(20) NOT NULL,
    PRIMARY KEY (DocID, UserID)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
