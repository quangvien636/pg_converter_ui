-- ─── TABLE: WFAXAttached ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WFAXAttached" (
    FaxFg character varying(4) NOT NULL,
    Seq integer NOT NULL,
    FileSeq integer NOT NULL,
    FileNm character varying(500),
    FileSize integer,
    RegId character varying(50),
    RegYmd character varying(8),
    ModId character varying(50),
    ModYmd character varying(8),
    FilePages integer,
    PRIMARY KEY (FaxFg, Seq, FileSeq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
