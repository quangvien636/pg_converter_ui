-- ─── TABLE: Center_Configuration ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_Configuration" (
    ConfigNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Key character varying(50) NOT NULL,
    Value text
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
