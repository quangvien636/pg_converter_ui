-- ─── TABLE: DMake_InitForm ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_InitForm" (
    BoardNo integer NOT NULL PRIMARY KEY,
    FormContent text DEFAULT '',
    RegUserNo integer DEFAULT 0,
    RegDate timestamp without time zone DEFAULT now(),
    ModUserNo integer DEFAULT 0,
    ModDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
