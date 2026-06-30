-- ─── TABLE: EAPPDesignatedAdmin ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPDesignatedAdmin" (
    ID serial NOT NULL,
    UserID character varying(50) NOT NULL,
    Depart character varying(100) NOT NULL,
    Form character varying(100) NOT NULL,
    FromDate timestamp without time zone,
    ToDate timestamp without time zone,
    AuthView character(1) NOT NULL,
    AuthModify character(1) NOT NULL,
    DocProgress character(1) NOT NULL,
    DocReserve character(1) NOT NULL,
    DocReject character(1) NOT NULL,
    DocComplete character(1) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
