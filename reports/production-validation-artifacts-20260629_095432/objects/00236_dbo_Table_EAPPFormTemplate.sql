-- ─── TABLE: EAPPFormTemplate ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPFormTemplate" (
    EftID serial NOT NULL,
    EFormID integer NOT NULL,
    TemplateType character(1) NOT NULL,
    Content text,
    RegDate timestamp without time zone,
    RegID character varying(50),
    ModDate timestamp without time zone,
    ModID character varying(50),
    UseYN character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
