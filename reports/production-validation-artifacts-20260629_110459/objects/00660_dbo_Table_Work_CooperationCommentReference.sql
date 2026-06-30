-- ─── TABLE: Work_CooperationCommentReference ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Work_CooperationCommentReference" (
    CommentReferenceNo serial NOT NULL,
    CommentNo integer,
    UserNo integer,
    ReadDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
