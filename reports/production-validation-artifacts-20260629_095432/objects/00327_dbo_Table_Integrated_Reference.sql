-- ─── TABLE: Integrated_Reference ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Integrated_Reference" (
    ReferenceNo serial NOT NULL,
    IntegratedNo integer,
    UserID character varying(100),
    ReadDate timestamp without time zone,
    Department character varying(100),
    Position character varying(100),
    Name character varying(100),
    UserNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
