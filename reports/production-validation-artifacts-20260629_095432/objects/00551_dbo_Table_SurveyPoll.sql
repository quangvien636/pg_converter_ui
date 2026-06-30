-- ─── TABLE: SurveyPoll ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SurveyPoll" (
    SurveyNo integer NOT NULL,
    DetailNo integer NOT NULL,
    UserNo integer NOT NULL,
    SelectNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    PRIMARY KEY (SurveyNo, DetailNo, UserNo, SelectNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
