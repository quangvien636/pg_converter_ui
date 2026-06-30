-- ─── FUNCTION: schedule_deleteddaysgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteddaysgroup();
CREATE OR REPLACE FUNCTION public.schedule_deleteddaysgroup(
) RETURNS void
AS $function$
BEGIN



    -- INSERT INTO statements for procedure here
	SELECT GroupCnt = COUNT(GroupNo) FROM ScheduleDdays 
	WHERE GroupNo =  GroupNo
	
	IF GroupCnt = 0
	BEGIN;
		DELETE FROM ScheduleDdayGroups
		WHERE GroupNo = GroupNo
	END
	ELSE
	BEGIN;
		UPDATE ScheduleDdays
		SET 
			GroupNo = 0
		WHERE GroupNo = GroupNo
		
		DELETE FROM ScheduleDdayGroups
		WHERE GroupNo = GroupNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
