-- ─── FUNCTION: noticesyn_setfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_setfiles(integer, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.noticesyn_setfiles(
    noticeno integer,
    filename character varying,
    filelength integer,
    filepath character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	IF Mode = '0'
	BEGIN;
		INSERT INTO NoticeSyn_Attachments(NoticeNo,FileName,FileLength,FilePath)
		VALUES(NoticeNo,FileName,FileLength,FilePath)
	END
	ELSE
	BEGIN;
		DELETE FROM NoticeSyn_Attachments WHERE NoticeNo = noticesyn_setfiles.noticeno
	END
	
	RETURN QUERY
	SELECT @ERROR
END;
--------------------------- ///////////////////--------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
