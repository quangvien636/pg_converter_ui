-- ─── TABLE: EAPPWorkTransfer ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPWorkTransfer" (
    id serial NOT NULL,
    TransferDate timestamp without time zone,
    Sender character varying(50),
    Receiver character varying(50),
    Manager character varying(50),
    SenderOrgcd character(10)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
