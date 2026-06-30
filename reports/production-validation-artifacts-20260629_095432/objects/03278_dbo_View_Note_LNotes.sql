-- TODO: view conversion is not implemented yet: dbo.Note_LNotes
-- RAW:
CREATE VIEW dbo.Note_LNotes
AS
SELECT  ListNo AS NoteNo, Name, GroupNo, UserNo, Description, Latitude, Longitude, DayCreate AS DateCreated, DayEdit AS DateChanged, Show, 
               NoteTimeZoneCreate AS TimeZoneOffsetOfDateCreated, NoteTimeZoneEdit AS TimeZoneOffsetOfDateChanged, FavoriteType AS IsFavorite, ReadDate AS DateRead, 
               NoteTimeZoneRead AS TimeZoneOffsetOfDateRead
FROM     dbo.Note_List

-- OWNER: postgres
