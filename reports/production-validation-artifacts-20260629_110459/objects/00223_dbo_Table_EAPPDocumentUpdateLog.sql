-- ─── TABLE: EAPPDocumentUpdateLog ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPDocumentUpdateLog" (
    id serial NOT NULL,
    docid integer NOT NULL,
    userid character(50),
    regdate timestamp without time zone NOT NULL DEFAULT now(),
    path character varying(2000)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
