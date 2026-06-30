-- ─── VIEW: Note_LComments ───────────────────────────────
DROP VIEW IF EXISTS public."Note_LComments";
CREATE OR REPLACE VIEW public."Note_LComments" AS
SELECT  CommentNo, ListNo AS NoteNo, RegUserNo AS UserNo, RegDate AS DateCreated, ModUserNo, ModDate AS DateChanged, Content, RegTimeZone AS TimeZoneOffsetOfDateCreated, 
               ModTimeZone AS TimeZoneOffsetOfDateChanged, ReadUserList, ParentID AS ParentNo, ContentHTML
FROM     public.Note_Comments
;
-- TODO: Owner mapping skipped. Target role postgres not verified.
