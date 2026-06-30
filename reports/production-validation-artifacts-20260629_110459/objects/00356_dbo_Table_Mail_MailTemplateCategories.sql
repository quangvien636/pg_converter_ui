-- ─── TABLE: Mail_MailTemplateCategories ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailTemplateCategories" (
    CategoryNo serial NOT NULL,
    Name character varying(200) NOT NULL,
    SortNo integer NOT NULL,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
