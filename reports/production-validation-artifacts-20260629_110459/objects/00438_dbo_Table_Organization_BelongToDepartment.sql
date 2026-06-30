-- ─── TABLE: Organization_BelongToDepartment ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Organization_BelongToDepartment" (
    BelongNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    DepartNo integer NOT NULL,
    PositionNo integer NOT NULL,
    DutyNo integer NOT NULL DEFAULT -1,
    IsDefault boolean NOT NULL DEFAULT '1'
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
