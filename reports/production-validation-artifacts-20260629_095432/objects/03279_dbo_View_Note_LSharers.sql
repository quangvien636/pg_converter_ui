-- TODO: view conversion is not implemented yet: dbo.Note_LSharers
-- RAW:
CREATE VIEW dbo.Note_LSharers
AS
SELECT  ShareNo, UserNo, ListNo AS NoteNo, DayCreate AS DateCreated, DayEdit AS DateChanged, UserShare, GroupNo, CONVERT(INT, IsRead) AS IsRead, ReadDate AS DateRead, IsReads, 
               FavoriteType AS IsFavorite, ShareType, timeOffset AS TimeZoneOffsetOfDateRead, CompanyNo, ShareCompanyNo
FROM     dbo.Note_Share

-- OWNER: postgres
