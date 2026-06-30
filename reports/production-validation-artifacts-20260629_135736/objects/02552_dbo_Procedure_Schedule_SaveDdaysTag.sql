-- ─── PROCEDURE→FUNCTION: schedule_saveddaystag ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_saveddaystag(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_saveddaystag(
    IN groupno integer,
    IN tagimageno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
	SELECT COUNT(TagImageNo) INTO count FROM ScheduleDdaysTag
	WHERE UserNo = UserNo AND GroupNo = schedule_saveddaystag.groupno
	
	IF COUNT = 0 THEN;
		INSERT INTO ScheduleDdaysTag
			   (UserNo
			   ,GroupNo
			   ,TagImageNo)
		 VALUES
			   (UserNo,
				GroupNo,
				TagImageNo)
	END IF;
	ELSE;
		UPDATE 	ScheduleDdaysTag
		TagImageNo := schedule_saveddaystag.tagimageno;
		WHERE UserNo = UserNo
		AND GroupNo = schedule_saveddaystag.groupno
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
