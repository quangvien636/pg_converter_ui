-- ─── TABLE: SnsReplyChk ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsReplyChk" (
    ReplyChkNo serial NOT NULL,
    ReplyNo integer,
    UserNo integer,
    GroupNo integer,
    IsCheck boolean,
    Regdate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
