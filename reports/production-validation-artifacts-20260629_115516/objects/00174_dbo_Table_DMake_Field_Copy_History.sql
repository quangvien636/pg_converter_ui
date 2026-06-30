-- ─── TABLE: DMake_Field_Copy_History ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Field_Copy_History" (
    BoardNo integer NOT NULL DEFAULT 0,
    OldFieldNo integer NOT NULL DEFAULT 0,
    NewFieldNo integer NOT NULL DEFAULT 0,
    HistoryDate timestamp without time zone DEFAULT now(),
    PRIMARY KEY (BoardNo, OldFieldNo, NewFieldNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
