-- ─── TABLE: SurveyExample ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SurveyExample" (
    SurveyNo integer NOT NULL,
    ExampleNo bigserial NOT NULL,
    ExampleText character varying(300),
    ExampleEtc character(1) NOT NULL,
    ExampleOrder character(3) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
