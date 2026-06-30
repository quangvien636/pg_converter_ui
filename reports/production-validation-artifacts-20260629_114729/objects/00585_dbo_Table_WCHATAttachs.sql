-- ─── TABLE: WCHATAttachs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WCHATAttachs" (
    AttachNo integer,
    FileName character varying(200),
    FileType integer,
    FilePath text,
    RegDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
