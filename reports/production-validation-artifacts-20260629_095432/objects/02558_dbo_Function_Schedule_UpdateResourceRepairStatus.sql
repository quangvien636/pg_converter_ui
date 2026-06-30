-- ─── FUNCTION: schedule_updateresourcerepairstatus ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateresourcerepairstatus(character varying);
CREATE OR REPLACE FUNCTION public.schedule_updateresourcerepairstatus(
    status character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	
	SELECT ResourceNo = ResourceNo FROM ScheduleResourcesRepair WHERE RepairNo = RepairNo
	
	UPDATE ScheduleResourcesRepair
	SET
		Status = schedule_updateresourcerepairstatus.status,
		ModDate = NOW(),
		ModUserNo = UserNo
	WHERE RepairNo = RepairNo
	-- 자원쪽 상태 변경 처리
	
	IF Status = 'F'
	BEGIN;
		UPDATE ScheduleResourcesRepair
		SET
			EndDate = NOW()
		WHERE RepairNo = RepairNo
	
		UPDATE ScheduleResources
		SET
			IsRepair = FALSE,
			ModDate = NOW(),
			ModUserNo = UserNo
		WHERE ResourceNo = ResourceNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
