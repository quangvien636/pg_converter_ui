-- ─── TABLE: NoticeReference ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeReference" (
    ReferenceNo serial NOT NULL,
    NoticeNo integer,
    UserID character varying(100),
    ReadDate timestamp without time zone,
    Department character varying(100),
    Position character varying(100),
    Name character varying(100)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
