-- ─── TABLE: EAPPReceive ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPReceive" (
    ID serial NOT NULL,
    ProgID integer,
    ReceiverID character varying(50),
    ReceiveState integer,
    ReceiveDate timestamp without time zone,
    Comment text
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
