-- ─── TABLE: Main_UserWidgetPlacements ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Main_UserWidgetPlacements" (
    PlaceNo serial NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    BoardNo integer NOT NULL,
    TypeNo integer NOT NULL,
    WidgetData character varying(1000) NOT NULL,
    "Left" integer NOT NULL,
    Top integer NOT NULL,
    Width integer NOT NULL,
    Height integer NOT NULL,
    ZIndex integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
