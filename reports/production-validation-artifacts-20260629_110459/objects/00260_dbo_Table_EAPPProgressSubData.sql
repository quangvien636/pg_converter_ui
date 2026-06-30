-- ─── TABLE: EAPPProgressSubData ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPProgressSubData" (
    id serial NOT NULL,
    progid integer,
    PreManageState integer,
    PreManageDate timestamp without time zone,
    PreDocumentID integer,
    PreManagerID character varying(100),
    PreAccessType integer,
    PreLineOrder integer,
    PreArriveState integer,
    PreArriveDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
