-- ─── TABLE: Work_CooperationComments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Work_CooperationComments" (
    CommentNo serial NOT NULL,
    GroupNo integer NOT NULL,
    CooperationNo integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Content text NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
