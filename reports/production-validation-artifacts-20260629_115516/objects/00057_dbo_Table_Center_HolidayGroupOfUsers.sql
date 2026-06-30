-- ─── TABLE: Center_HolidayGroupOfUsers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Center_HolidayGroupOfUsers" (
    UserNo integer NOT NULL PRIMARY KEY,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    GroupNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
