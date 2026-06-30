-- ─── TABLE: SnsMessageChk ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsMessageChk" (
    MessageChkNo serial NOT NULL,
    MessageNo integer,
    UserNo integer,
    GroupNo integer,
    IsCheck boolean,
    Regdate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
