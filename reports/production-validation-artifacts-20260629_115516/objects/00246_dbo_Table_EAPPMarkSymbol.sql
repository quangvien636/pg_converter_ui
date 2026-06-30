-- ─── TABLE: EAPPMarkSymbol ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPMarkSymbol" (
    ID serial NOT NULL,
    UserID character varying(50),
    Symbol character(1),
    Color character(6),
    ActCode integer,
    Auth integer,
    IsDelete character(1),
    SortOrd integer,
    Description character varying(100)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
