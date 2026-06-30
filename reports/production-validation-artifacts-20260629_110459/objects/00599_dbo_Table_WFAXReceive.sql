-- ─── TABLE: WFAXReceive ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WFAXReceive" (
    Seq serial NOT NULL,
    UserId character varying(50),
    Title character varying(100),
    StatFg character varying(4),
    intID integer,
    RegId character varying(50),
    RegYmd character varying(8),
    ModId character varying(50),
    ModYmd character varying(8)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
