-- ─── TABLE: Notice_AuthoGroup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Notice_AuthoGroup" (
    AUTH_GRP_ID serial NOT NULL,
    AUTH_GRP_NM character varying(100) NOT NULL,
    USE_YN character(1),
    ID_INSERT integer NOT NULL,
    DTS_INSERT timestamp without time zone NOT NULL,
    ID_UPDATE integer,
    DTS_UPDATE timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
