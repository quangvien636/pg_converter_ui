-- ─── TABLE: WorkingTimeV3_Permisions ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTimeV3_Permisions" (
    UserNo integer NOT NULL PRIMARY KEY,
    ModDate timestamp without time zone,
    RegDate timestamp without time zone,
    IsUserFull boolean
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
