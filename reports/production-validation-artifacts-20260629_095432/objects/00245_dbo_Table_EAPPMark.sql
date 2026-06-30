-- ─── TABLE: EAPPMark ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPMark" (
    ID serial NOT NULL,
    UserID character varying(50),
    DocID character varying(50),
    SymbolID integer,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
