-- ─── TABLE: DMake_Widget ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Widget" (
    Type character varying(1) NOT NULL,
    BoardNo integer NOT NULL,
    SortNo integer,
    PRIMARY KEY (Type, BoardNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
