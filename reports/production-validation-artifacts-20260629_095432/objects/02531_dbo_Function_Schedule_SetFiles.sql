-- ─── FUNCTION: schedule_setfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_setfiles(character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_setfiles(
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
		INSERT INTO ScheduleContentsAttachments(ScheduleNo,FileName,FileLength,FilePath)
		VALUES(ScheduleNo,FileName,FileLength,FilePath)
	END
	ELSE IF Mode = 1
	BEGIN;
		DELETE FROM ScheduleContentsAttachments WHERE ScheduleNo = ScheduleNo
	END
	ELSE IF Mode = 2
	BEGIN;
		DELETE FROM ScheduleContentsAttachments WHERE ScheduleNo = ScheduleNo ANd FileName = schedule_setfiles.filename;
	END

	RETURN QUERY
	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
