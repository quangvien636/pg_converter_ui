-- ─── TABLE: SurveyComments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SurveyComments" (
    CommentNo serial NOT NULL,
    SurveyNo integer NOT NULL,
    Content character varying(500) NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
