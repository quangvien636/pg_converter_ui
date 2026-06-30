-- ─── TABLE: WFAXSend ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WFAXSend" (
    Seq serial NOT NULL,
    UserId character varying(50),
    Title character varying(100),
    PriorityYn character varying(1),
    intID integer,
    SenderIp character varying(20),
    StatFg character varying(4),
    RegId character varying(50),
    RegYmd character varying(8),
    ModId character varying(50),
    ModYmd character varying(8)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
