-- ─── TABLE: WFAXBoxSet ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WFAXBoxSet" (
    Seq integer NOT NULL,
    FaxFg character varying(4) NOT NULL,
    UserId character varying(50) NOT NULL,
    FaxBoxCd character varying(4) NOT NULL,
    StatFg character varying(4),
    RegId character varying(50),
    RegYmd character varying(8),
    ModId character varying(50),
    ModYmd character varying(8),
    ReadDt timestamp without time zone,
    PRIMARY KEY (Seq, FaxFg, UserId, FaxBoxCd)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
