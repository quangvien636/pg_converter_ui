-- ─── FUNCTION: note_lgetattachments ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_lgetattachments(uuid);
CREATE OR REPLACE FUNCTION public.note_lgetattachments(
    noteno uuid
) RETURNS TABLE(
    attachmentno text,
    userno text,
    fileurl text,
    listno text,
    typefile text,
    daycreate text,
    dayedit text,
    fileuri text,
    realpath text,
    isavatar text,
    attachtimezone text,
    filesize text,
    filename text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT AttachmentNo, UserNo, FileUrl, ListNo, TypeFile, DayCreate, DayEdit, fileURI, RealPath,
		IsAvatar, AttachTimeZone, FileSize, FileName
	FROM Note_Attachment
	WHERE ListNo = note_lgetattachments.noteno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
