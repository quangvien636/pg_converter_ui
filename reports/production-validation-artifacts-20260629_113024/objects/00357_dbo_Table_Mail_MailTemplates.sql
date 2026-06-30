-- ─── TABLE: Mail_MailTemplates ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_MailTemplates" (
    TemplateNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    CategoryNo integer NOT NULL,
    Name character varying(200) NOT NULL,
    Content text NOT NULL,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
