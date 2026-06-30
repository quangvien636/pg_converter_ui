-- ─── TABLE: EAPPErpUpdate ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPErpUpdate" (
    UpdateKey serial NOT NULL,
    EADocID integer NOT NULL,
    Result character(1) NOT NULL,
    ResultMemo character varying(4000),
    RegUserID character varying(100) NOT NULL,
    RegDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
