-- ─── TABLE: SnsReplys ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SnsReplys" (
    ReplyNo serial NOT NULL,
    MessageNo integer,
    UserNo integer,
    Message character varying(8000),
    GroupNo integer,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
