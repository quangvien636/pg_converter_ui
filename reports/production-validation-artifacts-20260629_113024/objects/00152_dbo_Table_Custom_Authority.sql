-- ─── TABLE: Custom_Authority ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Custom_Authority" (
    CustomAuthorityNo serial NOT NULL,
    CustomId character varying(500),
    CustomName character varying(500),
    UserNo integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
