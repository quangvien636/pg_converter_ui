-- ─── TABLE: SMSFavoritesText ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SMSFavoritesText" (
    FavNo serial NOT NULL,
    UserNo integer,
    FavType character varying(1),
    FavText character varying(2000),
    SortOrder integer,
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModDate timestamp without time zone
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
