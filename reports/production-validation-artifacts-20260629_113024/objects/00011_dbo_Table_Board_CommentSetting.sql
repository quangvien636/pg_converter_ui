-- ─── TABLE: Board_CommentSetting ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_CommentSetting" (
    No serial NOT NULL,
    BoardNo integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL DEFAULT now(),
    IsDelete boolean DEFAULT 'FALSE'
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
