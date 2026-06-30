-- ─── TABLE: EAPPApprovalExtend ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPApprovalExtend" (
    id serial NOT NULL,
    docid integer,
    progid integer,
    arrivedate timestamp without time zone,
    delaydate timestamp without time zone,
    delaycount integer,
    isUsing character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
