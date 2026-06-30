-- ─── TABLE: WFAXRead ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WFAXRead" (
    Seq integer NOT NULL,
    FaxFg character varying(4) NOT NULL,
    UserId character varying(50) NOT NULL,
    ReadCnt integer,
    ReadTime character varying(50),
    PRIMARY KEY (Seq, FaxFg, UserId)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
