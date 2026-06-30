-- ─── TABLE: EAPPSignFile ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPSignFile" (
    ID serial NOT NULL,
    Category character varying(100),
    SortOrder integer,
    ShowName character varying(500),
    FullPath character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
