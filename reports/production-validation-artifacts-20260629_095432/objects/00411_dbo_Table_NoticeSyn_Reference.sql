-- ─── TABLE: NoticeSyn_Reference ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeSyn_Reference" (
    ReferenceNo serial NOT NULL,
    NoticeNo integer,
    UserID character varying(100),
    ReadDate timestamp without time zone,
    Department character varying(100),
    Position character varying(100),
    Name character varying(100),
    DepartNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
