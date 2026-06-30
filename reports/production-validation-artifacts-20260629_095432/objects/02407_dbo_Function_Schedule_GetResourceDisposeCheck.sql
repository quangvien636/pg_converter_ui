-- ─── FUNCTION: schedule_getresourcedisposecheck ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcedisposecheck();
CREATE OR REPLACE FUNCTION public.schedule_getresourcedisposecheck(
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    repaircnt integer;
    disposecnt integer;
BEGIN

	


	-- 수리하고 있는 것인지...확인
	SELECT RepairCnt = COUNT(RepairNo) FROM ScheduleResourcesRepair
	WHERE ResourceNo = ResourceNo
	AND Status IN ('R','I') -- 접수중/업체처리중
	
	IF RepairCnt > 0
	BEGIN
		RETURN QUERY
		SELECT 1 AS RC
		RETURN
	END
	ELSE
	BEGIN
		-- 이미 폐기된것이지 확인
		SELECT DisposeCnt = COUNT(DisposeNo) FROM ScheduleResourcesDispose
		WHERE ResourceNo = ResourceNo
		
		IF DisposeCnt > 0
		BEGIN
			RETURN QUERY
			SELECT 2 AS RC
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT 0 AS RC
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
