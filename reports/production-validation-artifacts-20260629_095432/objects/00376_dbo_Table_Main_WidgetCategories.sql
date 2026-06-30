-- ─── TABLE: Main_WidgetCategories ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Main_WidgetCategories" (
    CategoryNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    ParentNo integer NOT NULL,
    Name character varying(100) NOT NULL,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
