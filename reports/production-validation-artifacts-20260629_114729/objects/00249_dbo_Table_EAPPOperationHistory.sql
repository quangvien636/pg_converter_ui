-- ─── TABLE: EAPPOperationHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPOperationHistory" (
    ID serial NOT NULL,
    OpSerial character varying(200),
    OpSerialNum integer,
    OpID integer NOT NULL,
    DocID integer NOT NULL,
    IsSend character(1),
    Content text,
    Description character varying(100),
    Receiver character varying(400),
    Title character varying(400),
    Reference character varying(400),
    DocSerial character varying(100),
    OperationDate character varying(50),
    HiddenFile character(1),
    receivebottom character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
