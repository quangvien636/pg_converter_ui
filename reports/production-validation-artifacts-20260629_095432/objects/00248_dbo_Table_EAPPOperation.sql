-- ─── TABLE: EAPPOperation ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPOperation" (
    ID serial NOT NULL,
    DocID integer,
    IsSend character(1),
    Content text,
    Description character varying(100),
    Receiver character varying(400),
    Title character varying(400),
    Reference character varying(400),
    DocSerial character varying(100),
    OperationDate character varying(50),
    HiddenFile character(1),
    receivebottom character(1),
    IsAllow character(1) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
