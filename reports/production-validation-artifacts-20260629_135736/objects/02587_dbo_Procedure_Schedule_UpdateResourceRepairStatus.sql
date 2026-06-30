-- ─── PROCEDURE→FUNCTION: schedule_updateresourcerepairstatus ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_updateresourcerepairstatus(character varying);
CREATE OR REPLACE FUNCTION public.schedule_updateresourcerepairstatus(
    IN status character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
	SELECT ResourceNo INTO resourceno FROM ScheduleResourcesRepair WHERE RepairNo = RepairNo
	
	UPDATE ScheduleResourcesRepair
	SET
		Status = schedule_updateresourcerepairstatus.status,
		ModDate = NOW(),
		ModUserNo = UserNo
	WHERE RepairNo = RepairNo
	-- 자원쪽 상태 변경 처리
	
	IF Status = 'F' THEN;
		UPDATE ScheduleResourcesRepair
		EndDate := NOW();
		WHERE RepairNo = RepairNo
	
		UPDATE ScheduleResources
		IsRepair := 0,;
			ModDate = NOW(),
			ModUserNo = UserNo
		WHERE ResourceNo = ResourceNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
