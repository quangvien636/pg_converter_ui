-- ─── TABLE: VW_HR_GW_TIME_INOUT ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."VW_HR_GW_TIME_INOUT" (
    EMP_NO integer NOT NULL,
    WORK_DATE integer NOT NULL,
    TOT_HOLIDAYS double precision,
    USE_HOLIDAYS double precision,
    JAN_HOLIDAYS double precision,
    ORG_ATTEND_TIME character varying(14),
    ORG_FINISH_TIME character varying(14),
    ATTEND_TIME character varying(14),
    FINISH_TIME character varying(14),
    ABSENCE_NAME character varying(200),
    insertDate integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
