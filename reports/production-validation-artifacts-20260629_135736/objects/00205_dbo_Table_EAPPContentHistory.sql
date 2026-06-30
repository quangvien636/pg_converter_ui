-- ─── TABLE: EAPPContentHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPContentHistory" (
    id serial NOT NULL,
    content text,
    regdate timestamp without time zone,
    Contentid integer,
    Docid integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
