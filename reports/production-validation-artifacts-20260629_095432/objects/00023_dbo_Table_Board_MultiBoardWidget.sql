-- ─── TABLE: Board_MultiBoardWidget ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_MultiBoardWidget" (
    No serial NOT NULL,
    BoardNo integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    IsDelete boolean,
    Sort integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
