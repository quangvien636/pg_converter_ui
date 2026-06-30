-- ─── FUNCTION: crewchat_insertattachfiledata ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_insertattachfiledata(character varying, character varying, integer, bigint, integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertattachfiledata(
    filename character varying,
    fullpath character varying,
    type integer,
    size bigint,
    thumbwidth integer,
    thumbheight integer
) RETURNS TABLE(
    attachno text,
    filename text,
    fullpath text,
    type text,
    size text,
    thumbwidth text,
    thumbheight text
)
AS $function$
DECLARE
    attachno bigint;
BEGIN


	INSERT INTO CrewChat_Attach (FileName, FullPath, Type, Size, ThumbWidth, ThumbHeight)
	VALUES (FileName, FullPath, Type, Size, ThumbWidth, ThumbHeight)
	
	SET AttachNo = lastval()
	
	RETURN QUERY
	SELECT AttachNo, FileName, FullPath, Type, Size, ThumbWidth, ThumbHeight  FROM CrewChat_Attach
	WHERE AttachNo = AttachNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
