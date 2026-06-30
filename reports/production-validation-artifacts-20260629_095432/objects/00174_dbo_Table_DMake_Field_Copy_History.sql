-- ─── TABLE: DMake_Field_Copy_History ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Field_Copy_History" (
    BoardNo integer NOT NULL,
    OldFieldNo integer NOT NULL,
    NewFieldNo integer NOT NULL,
    HistoryDate timestamp without time zone,
    PRIMARY KEY (BoardNo, OldFieldNo, NewFieldNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
