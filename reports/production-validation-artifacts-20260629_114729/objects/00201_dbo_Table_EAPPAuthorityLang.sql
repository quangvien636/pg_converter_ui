-- ─── TABLE: EAPPAuthorityLang ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPAuthorityLang" (
    Authoritylevel integer NOT NULL,
    Kor character varying(8) NOT NULL,
    Eng character varying(17) NOT NULL,
    Chi character varying(9) NOT NULL,
    Jap character varying(9) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
