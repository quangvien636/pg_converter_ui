-- ─── FUNCTION: notice_setfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_setfiles(integer, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.notice_setfiles(
    noticeno integer,
    filename character varying,
    filelength integer,
    filepath character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	IF Mode = 0
	BEGIN;
		INSERT INTO NoticeAttachments(NoticeNo,FileName,FileLength,FilePath)
		VALUES(NoticeNo,FileName,FileLength,FilePath)
	END
	ELSE
	BEGIN;
		DELETE FROM NoticeAttachments WHERE NoticeNo = notice_setfiles.noticeno
	END
	
	RETURN QUERY
	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
