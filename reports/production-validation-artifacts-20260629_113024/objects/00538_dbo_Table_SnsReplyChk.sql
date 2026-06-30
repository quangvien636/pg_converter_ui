-- ─── TABLE: SnsReplyChk ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsReplyChk" (
    ReplyChkNo serial NOT NULL,
    ReplyNo integer,
    UserNo integer,
    GroupNo integer,
    IsCheck boolean DEFAULT false,
    Regdate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
