-- ─── TABLE: Note_List ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Note_List" (
-- TODO: NEWID() requires manual rewrite or uuid-ossp extension on PostgreSQL 9.3.
    ListNo uuid NOT NULL PRIMARY KEY,
    Name character varying(250),
    GroupNo uuid,
    UserNo integer,
    Description text,
    Latitude double precision,
    Longitude double precision,
    DayCreate timestamp without time zone,
    DayEdit timestamp without time zone,
    Show integer DEFAULT 1,
    NoteTimeZoneCreate double precision DEFAULT 0,
    NoteTimeZoneEdit double precision DEFAULT 0,
    FavoriteType integer DEFAULT 0,
    ReadDate timestamp without time zone DEFAULT now(),
    NoteTimeZoneRead double precision DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
