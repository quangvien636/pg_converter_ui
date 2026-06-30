-- ─── TABLE: RegularWorkGroupsCSCSync ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."RegularWorkGroupsCSCSync" (
    GroupNo integer NOT NULL,
    CompanyID integer NOT NULL,
    PRIMARY KEY (GroupNo, CompanyID)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
