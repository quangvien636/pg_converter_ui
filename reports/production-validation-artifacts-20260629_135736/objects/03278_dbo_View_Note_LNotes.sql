-- ─── VIEW: Note_LNotes ───────────────────────────────
DROP VIEW IF EXISTS public."Note_LNotes";
CREATE OR REPLACE VIEW public."Note_LNotes" AS
SELECT  ListNo AS NoteNo, Name, GroupNo, UserNo, Description, Latitude, Longitude, DayCreate AS DateCreated, DayEdit AS DateChanged, Show, 
               NoteTimeZoneCreate AS TimeZoneOffsetOfDateCreated, NoteTimeZoneEdit AS TimeZoneOffsetOfDateChanged, FavoriteType AS IsFavorite, ReadDate AS DateRead, 
               NoteTimeZoneRead AS TimeZoneOffsetOfDateRead
FROM     public.Note_List
;
-- TODO: Owner mapping skipped. Target role postgres not verified.
