-- ─── TABLE: EDMSReceive ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSReceive" (
    ID serial NOT NULL,
    DocID integer,
    ReceiverID character varying(50),
    ReceiveState integer,
    ReceiveDate timestamp without time zone,
    Comment text
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
