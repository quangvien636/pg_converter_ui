-- ─── TABLE: EAPPDocHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPDocHistory" (
    id serial NOT NULL,
    eadocid integer,
    content text,
    reference text,
    addinfo text,
    attach text,
    fileinfo text,
    docinfo text,
    modifier character varying(50),
    moddate timestamp without time zone NOT NULL DEFAULT now(),
    wbldcontentid integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
