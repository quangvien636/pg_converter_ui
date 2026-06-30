-- ─── TABLE: eappdocument_hiddencontent ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."eappdocument_hiddencontent" (
    id serial NOT NULL,
    docid integer,
    content text,
    title character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
