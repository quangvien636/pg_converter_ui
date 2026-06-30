-- ─── TABLE: SnsMessageChk ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsMessageChk" (
    MessageChkNo serial NOT NULL,
    MessageNo integer,
    UserNo integer,
    GroupNo integer,
    IsCheck boolean DEFAULT false,
    Regdate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
