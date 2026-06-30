-- ─── FUNCTION: note_getavatarfornote ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getavatarfornote(uuid);
CREATE OR REPLACE FUNCTION public.note_getavatarfornote(
    listno uuid
) RETURNS TABLE(
    attachmentno uuid,
    userno integer,
    fileurl character varying(250),
    listno uuid,
    typefile character varying(50),
    daycreate timestamp without time zone,
    dayedit timestamp without time zone,
    fileuri character varying(250),
    realpath character varying(250),
    isavatar boolean,
    attachtimezone double precision,
    filesize character varying(200),
    filename character varying(500)
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM Note_Attachment 
	WHERE ListNo=note_getavatarfornote.listno and IsAvatar = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
