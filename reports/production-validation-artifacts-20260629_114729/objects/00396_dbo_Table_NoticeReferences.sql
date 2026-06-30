-- ─── TABLE: NoticeReferences ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeReferences" (
    ReferenceNo serial NOT NULL,
    NoticeNo integer NOT NULL,
    UserNo integer NOT NULL,
    ReadDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
