-- ─── TABLE: erprbrdgmapping ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."erprbrdgmapping" (
    erpseq serial NOT NULL,
    empno character varying(50),
    userid character varying(50)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
