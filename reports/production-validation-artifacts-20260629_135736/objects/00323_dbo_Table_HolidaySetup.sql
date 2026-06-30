-- ─── TABLE: HolidaySetup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."HolidaySetup" (
    No serial NOT NULL,
    show boolean NOT NULL,
    Url character varying(4000) NOT NULL,
    Key character varying(4000) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
