-- ─── PROCEDURE→FUNCTION: schedule_deleteddaysgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteddaysgroup();
CREATE OR REPLACE FUNCTION public.schedule_deleteddaysgroup(
) RETURNS void
AS $function$
BEGIN



    -- INSERT INTO statements for procedure here
	SELECT COUNT(GroupNo) INTO groupcnt FROM ScheduleDdays 
	WHERE GroupNo =  GroupNo
	
	IF GroupCnt = 0 THEN;
		DELETE FROM ScheduleDdayGroups
		WHERE GroupNo = GroupNo
	END IF;
	ELSE;
		UPDATE ScheduleDdays
		GroupNo := 0;
		WHERE GroupNo = GroupNo
		
		DELETE FROM ScheduleDdayGroups
		WHERE GroupNo = GroupNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
