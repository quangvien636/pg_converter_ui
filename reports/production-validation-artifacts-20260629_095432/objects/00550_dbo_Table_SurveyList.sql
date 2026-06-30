-- ─── TABLE: SurveyList ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SurveyList" (
    SurveyNo serial NOT NULL,
    SurveyTitle character varying(200) NOT NULL,
    SurveyCnt smallint NOT NULL,
    SurveyChartType character(1),
    SurveyStartDate timestamp without time zone,
    SurveyEndDate timestamp without time zone,
    SurveyMailSend character(1) NOT NULL,
    SurveyPopup character(1) NOT NULL,
    SurveyPurpose text,
    SurveyImportent character(1) NOT NULL,
    RegUser integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModifyUser integer NOT NULL,
    ModifyDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
