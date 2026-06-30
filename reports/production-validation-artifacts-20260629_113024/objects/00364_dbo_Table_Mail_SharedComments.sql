-- ─── TABLE: Mail_SharedComments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_SharedComments" (
    CommentNo serial NOT NULL,
    MailNo bigint NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    CommentsType integer NOT NULL,
    Content text NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
