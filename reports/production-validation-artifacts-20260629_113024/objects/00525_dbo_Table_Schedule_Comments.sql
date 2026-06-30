-- ─── TABLE: Schedule_Comments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Schedule_Comments" (
    CommentNo serial NOT NULL,
    ScheduleNo integer NOT NULL,
    Content text NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
