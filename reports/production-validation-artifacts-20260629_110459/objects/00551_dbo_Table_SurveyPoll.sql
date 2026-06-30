-- ─── TABLE: SurveyPoll ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SurveyPoll" (
    SurveyNo integer NOT NULL DEFAULT 0,
    DetailNo integer NOT NULL DEFAULT 0,
    UserNo integer NOT NULL,
    SelectNo integer NOT NULL DEFAULT '',
    RegDate timestamp without time zone NOT NULL,
    PRIMARY KEY (SurveyNo, DetailNo, UserNo, SelectNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
