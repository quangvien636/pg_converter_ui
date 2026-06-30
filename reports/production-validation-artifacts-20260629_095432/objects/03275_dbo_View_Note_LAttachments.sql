-- TODO: view conversion is not implemented yet: dbo.Note_LAttachments
-- RAW:
CREATE VIEW dbo.Note_LAttachments
AS
SELECT  AttachmentNo, UserNo, FileUrl, ListNo AS NoteNo, TypeFile, DayCreate AS DateCreated, DayEdit AS DateChanged, fileURI AS FileURI, RealPath, IsAvatar AS IsRepresentative, 
               AttachTimeZone AS TimeZoneOffsetOfDateCreated, FileSize, FileName
FROM     dbo.Note_Attachment

-- OWNER: postgres
