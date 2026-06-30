-- ─── TABLE: EAPPDocumentSubData ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPDocumentSubData" (
    id serial NOT NULL,
    docid integer,
    WorkCode character varying(100),
    WorkName character varying(200)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
