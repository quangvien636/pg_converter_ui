-- ─── TABLE: Board_Heads ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_Heads" (
    HeadNo serial NOT NULL,
    BoardNo integer NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(100) NOT NULL,
    SortNo integer NOT NULL,
    Enabled boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
