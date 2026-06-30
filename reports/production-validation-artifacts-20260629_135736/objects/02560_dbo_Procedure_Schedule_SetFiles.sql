-- ─── PROCEDURE→FUNCTION: schedule_setfiles ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_setfiles(character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_setfiles(
    IN filename character varying,
    IN filelength integer,
    IN filepath character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = 0 THEN;
		INSERT INTO ScheduleContentsAttachments(ScheduleNo,FileName,FileLength,FilePath)
		VALUES(ScheduleNo,FileName,FileLength,FilePath)
	END IF;
	ELSIF Mode = 1 THEN;
		DELETE FROM ScheduleContentsAttachments WHERE ScheduleNo = ScheduleNo
	END IF;
	ELSIF Mode = 2 THEN;
		DELETE FROM ScheduleContentsAttachments WHERE ScheduleNo = ScheduleNo ANd FileName = schedule_setfiles.filename;
	END IF;

	RETURN QUERY
	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
