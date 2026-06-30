-- ─── TABLE: EAPPGPDocPackContent ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPGPDocPackContent" (
    seq serial NOT NULL,
    headerseq integer NOT NULL,
    filename character varying(200),
    filepath character varying(400),
    contentrole character varying(20),
    contenttype character varying(20),
    charset character varying(20),
    encoding character varying(20)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
