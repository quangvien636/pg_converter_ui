-- ─── TABLE: Note_List ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Note_List" (
    ListNo uuid NOT NULL PRIMARY KEY,
    Name character varying(250),
    GroupNo uuid,
    UserNo integer,
    Description text,
    Latitude double precision,
    Longitude double precision,
    DayCreate timestamp without time zone,
    DayEdit timestamp without time zone,
    Show integer,
    NoteTimeZoneCreate double precision,
    NoteTimeZoneEdit double precision,
    FavoriteType integer,
    ReadDate timestamp without time zone,
    NoteTimeZoneRead double precision
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
