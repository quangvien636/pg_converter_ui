-- ─── TABLE: DMake_InitForm ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_InitForm" (
    BoardNo integer NOT NULL PRIMARY KEY,
    FormContent text,
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
