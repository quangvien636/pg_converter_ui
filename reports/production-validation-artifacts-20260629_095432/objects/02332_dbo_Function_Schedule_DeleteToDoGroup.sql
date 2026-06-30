-- ─── FUNCTION: schedule_deletetodogroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deletetodogroup();
CREATE OR REPLACE FUNCTION public.schedule_deletetodogroup(
) RETURNS void
AS $function$
BEGIN



    -- INSERT INTO statements for procedure here
	SELECT GroupCnt = COUNT(GroupNo) FROM ScheduleToDos 
	WHERE GroupNo =  GroupNo
	
	IF GroupCnt = 0
	BEGIN;
		DELETE FROM ScheduleToDoGroups
		WHERE GroupNo = GroupNo
	END
	ELSE
	BEGIN;
		UPDATE ScheduleToDos
		SET 
			GroupNo = 0
		WHERE GroupNo = GroupNo
		
		DELETE FROM ScheduleToDoGroups
		WHERE GroupNo = GroupNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
