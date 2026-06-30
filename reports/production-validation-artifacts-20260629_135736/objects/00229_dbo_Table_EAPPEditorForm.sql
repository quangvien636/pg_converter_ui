-- ─── TABLE: EAPPEditorForm ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPEditorForm" (
    seq serial NOT NULL,
    formid character varying(5),
    Title character varying(200),
    Content text,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
