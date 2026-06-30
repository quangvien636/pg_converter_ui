-- ─── TABLE: EAPPDecision ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPDecision" (
    DCCode character varying(30),
    DCName character varying(400),
    DCParentCode character varying(30),
    depth integer,
    SortOrd character varying(100),
    PathId integer,
    RegUserid character varying(100),
    RegDate timestamp without time zone,
    ModUserid character varying(100),
    ModDate timestamp without time zone,
    RangeFrom bigint,
    RangeTo bigint,
    DCName2 character varying(800),
    DCName3 character varying(800),
    DCName4 character varying(800)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
