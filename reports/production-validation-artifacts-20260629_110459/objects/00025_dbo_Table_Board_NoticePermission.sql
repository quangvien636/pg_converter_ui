-- ─── TABLE: Board_NoticePermission ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_NoticePermission" (
    AllowAccessNo serial NOT NULL,
    DepartNo integer NOT NULL,
    PositionNo integer NOT NULL,
    UserNo integer NOT NULL,
    AllowValue integer NOT NULL,
    ItemNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    RegDate timestamp without time zone NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
