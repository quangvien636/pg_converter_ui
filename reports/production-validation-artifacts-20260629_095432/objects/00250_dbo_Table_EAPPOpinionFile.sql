-- ─── TABLE: EAPPOpinionFile ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPOpinionFile" (
    ID serial NOT NULL,
    progid integer NOT NULL,
    saveFile_Name character varying(512),
    regdate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
