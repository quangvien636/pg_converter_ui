-- ─── TABLE: Main_InitialWidgetPlacements ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Main_InitialWidgetPlacements" (
    PlaceNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    WidgetNo integer NOT NULL,
    IsFixed boolean NOT NULL,
    Left integer NOT NULL,
    Top integer NOT NULL,
    Width integer NOT NULL,
    Height integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
