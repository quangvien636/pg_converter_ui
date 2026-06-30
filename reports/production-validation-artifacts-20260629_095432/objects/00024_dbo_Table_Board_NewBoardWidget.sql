-- ─── TABLE: Board_NewBoardWidget ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_NewBoardWidget" (
    No serial NOT NULL,
    BoardNo integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    IsDelete boolean,
    Sort integer,
    Type integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
