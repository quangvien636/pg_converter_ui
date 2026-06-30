-- ─── TABLE: EAPPATTEApprovalLog ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPATTEApprovalLog" (
    id serial NOT NULL,
    writerid character varying(100),
    attecode character varying(10),
    startymd character varying(10),
    endymd character varying(10),
    memo character varying(1000),
    rdoidx character varying(10),
    rdotype character varying(10)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
