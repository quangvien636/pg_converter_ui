-- ─── TABLE: TCMCalendarColor ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."TCMCalendarColor" (
    CommonCode integer NOT NULL PRIMARY KEY,
    ColorCode character varying(7)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
