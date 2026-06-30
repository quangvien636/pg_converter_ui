-- ─── TABLE: Main_DashBoards ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Main_DashBoards" (
    BoardNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Name character varying(50) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
