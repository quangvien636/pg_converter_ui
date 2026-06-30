-- ─── TABLE: Center_HRWorksLogs ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_HRWorksLogs" (
    HRWorksNo bigserial NOT NULL,
    HRWorksDate timestamp without time zone NOT NULL,
    UsersInsert integer NOT NULL,
    UsersUpdate integer NOT NULL,
    DepartmentsInsert integer NOT NULL,
    DepartmentsUpdate integer NOT NULL,
    DutiesInsert integer NOT NULL,
    DutiesUpdate integer NOT NULL,
    PositionsInsert integer NOT NULL,
    PositionsUpdate integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
