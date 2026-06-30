-- ─── PROCEDURE→FUNCTION: schedule_deletetodogroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deletetodogroup();
CREATE OR REPLACE FUNCTION public.schedule_deletetodogroup(
) RETURNS void
AS $function$
BEGIN



    -- INSERT INTO statements for procedure here
	SELECT COUNT(GroupNo) INTO groupcnt FROM ScheduleToDos 
	WHERE GroupNo =  GroupNo
	
	IF GroupCnt = 0 THEN;
		DELETE FROM ScheduleToDoGroups
		WHERE GroupNo = GroupNo
	END IF;
	ELSE;
		UPDATE ScheduleToDos
		GroupNo := 0;
		WHERE GroupNo = GroupNo
		
		DELETE FROM ScheduleToDoGroups
		WHERE GroupNo = GroupNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
