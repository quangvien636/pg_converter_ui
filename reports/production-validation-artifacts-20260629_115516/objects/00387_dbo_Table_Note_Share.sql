-- ─── TABLE: Note_Share ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Note_Share" (
    ShareNo uuid NOT NULL PRIMARY KEY,
    UserNo integer,
    ListNo uuid,
    DayCreate timestamp without time zone,
    DayEdit timestamp without time zone,
    UserShare integer,
    GroupNo uuid,
    IsRead boolean DEFAULT false,
    ReadDate timestamp without time zone DEFAULT now(),
    IsReads integer DEFAULT 0,
    FavoriteType integer DEFAULT 0,
    ShareType integer DEFAULT 2,
    timeOffset double precision,
    CompanyNo integer,
    ShareCompanyNo integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
