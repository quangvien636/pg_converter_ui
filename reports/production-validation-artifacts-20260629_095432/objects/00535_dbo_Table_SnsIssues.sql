-- ─── TABLE: SnsIssues ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsIssues" (
    IssueNo serial NOT NULL,
    IssueType integer,
    ActionType integer,
    GroupNo integer,
    ParentNo integer,
    Send_UserNo integer,
    Recv_UserNo integer,
    Message character varying(2000),
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
