-- ─── TABLE: Board_Config ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_Config" (
    ConfigNo serial NOT NULL,
    ConfigKey character varying(50) NOT NULL,
    ConfigValue character varying(500) NOT NULL,
    UserNo integer NOT NULL,
    LastestDate timestamp without time zone NOT NULL DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
