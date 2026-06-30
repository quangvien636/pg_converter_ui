-- TODO: view conversion is not implemented yet: dbo.Note_LComments
-- RAW:
CREATE VIEW dbo.Note_LComments
AS
SELECT  CommentNo, ListNo AS NoteNo, RegUserNo AS UserNo, RegDate AS DateCreated, ModUserNo, ModDate AS DateChanged, [Content], RegTimeZone AS TimeZoneOffsetOfDateCreated, 
               ModTimeZone AS TimeZoneOffsetOfDateChanged, ReadUserList, ParentID AS ParentNo, ContentHTML
FROM     dbo.Note_Comments

-- OWNER: postgres
