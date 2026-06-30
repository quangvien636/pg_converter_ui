-- ─── TABLE: Note_Comments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Note_Comments" (
    CommentNo uuid NOT NULL PRIMARY KEY,
    ListNo uuid NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Content text NOT NULL,
    RegTimeZone double precision DEFAULT 0,
    ModTimeZone double precision DEFAULT 0,
    ReadUserList text,
    ParentID uuid DEFAULT convert([uniqueidentifier],convert([binary],(0),(0)),(0)),
    ContentHTML text
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
