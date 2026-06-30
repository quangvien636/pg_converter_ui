-- ─── TABLE: EDMSUserAuthorityLevel ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSUserAuthorityLevel" (
    ID serial NOT NULL,
    UserId character varying(50),
    AuthorityLevel character varying(100),
    RegDate timestamp without time zone,
    Writer character varying(50)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
