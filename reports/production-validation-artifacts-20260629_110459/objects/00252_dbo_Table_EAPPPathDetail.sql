-- ─── TABLE: EAPPPathDetail ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPPathDetail" (
    ID serial NOT NULL,
    LineID integer,
    ManagerID character varying(50),
    DepartID character varying(4),
    PositionID character varying(4),
    GradeID character varying(4),
    Depth integer,
    AccessType integer,
    LineOrder integer,
    IsDelete character(1),
    Description character varying(500)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
