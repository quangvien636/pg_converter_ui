-- ─── TABLE: Main_Widgets ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Main_Widgets" (
    WidgetNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    CategoryNo integer NOT NULL,
    Width integer NOT NULL,
    Height integer NOT NULL,
    ControlUrl character varying(100) NOT NULL,
    IsCompany boolean NOT NULL,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
