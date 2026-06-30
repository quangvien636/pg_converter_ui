-- ─── VIEW: Note_LAttachments ───────────────────────────────
DROP VIEW IF EXISTS public."Note_LAttachments";
CREATE OR REPLACE VIEW public."Note_LAttachments" AS
SELECT  AttachmentNo, UserNo, FileUrl, ListNo AS NoteNo, TypeFile, DayCreate AS DateCreated, DayEdit AS DateChanged, fileURI AS FileURI, RealPath, IsAvatar AS IsRepresentative, 
               AttachTimeZone AS TimeZoneOffsetOfDateCreated, FileSize, FileName
FROM     public.Note_Attachment
;
-- TODO: Owner mapping skipped. Target role postgres not verified.
