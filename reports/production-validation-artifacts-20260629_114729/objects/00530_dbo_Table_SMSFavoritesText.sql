-- ─── TABLE: SMSFavoritesText ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."SMSFavoritesText" (
    FavNo serial NOT NULL,
    UserNo integer,
    FavType character varying(1) DEFAULT 'U',
    FavText character varying(2000),
    SortOrder integer DEFAULT 1,
    RegUserNo integer,
    RegDate timestamp without time zone DEFAULT now(),
    ModUserNo integer,
    ModDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
