-- ─── TABLE: Board_Boards ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_Boards" (
    BoardNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(4000),
    Description character varying(1000) NOT NULL,
    FolderNo integer NOT NULL,
    DisplayTypeNo integer NOT NULL,
    SortNo integer NOT NULL,
    IsReply boolean NOT NULL,
    IsHead boolean NOT NULL,
    IsNotice boolean NOT NULL,
    IsRecommend boolean NOT NULL,
    RecommendedDisplayCount integer NOT NULL,
    Enabled boolean NOT NULL,
    ViewMode integer,
    SpecType integer NOT NULL DEFAULT 1
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
