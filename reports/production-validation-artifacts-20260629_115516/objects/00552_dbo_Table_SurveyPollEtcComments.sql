-- ─── TABLE: SurveyPollEtcComments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SurveyPollEtcComments" (
    SurveyNo integer NOT NULL,
    DetailNo integer NOT NULL,
    UserNo integer NOT NULL,
    EtcComment character varying(300) NOT NULL DEFAULT '',
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (SurveyNo, DetailNo, UserNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
