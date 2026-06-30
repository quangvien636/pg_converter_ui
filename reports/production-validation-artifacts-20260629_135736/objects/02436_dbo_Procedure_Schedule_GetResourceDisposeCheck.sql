-- ─── PROCEDURE→FUNCTION: schedule_getresourcedisposecheck ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcedisposecheck();
CREATE OR REPLACE FUNCTION public.schedule_getresourcedisposecheck(
) RETURNS SETOF record
AS $function$
DECLARE
    repaircnt integer;
    disposecnt integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	


	-- 수리하고 있는 것인지...확인
	SELECT COUNT(RepairNo) INTO repaircnt FROM ScheduleResourcesRepair
	WHERE ResourceNo = ResourceNo
	AND Status IN ('R','I') -- 접수중/업체처리중
	
	IF RepairCnt > 0 THEN
		RETURN QUERY
		SELECT 1 AS RC
		RETURN
	END IF;
	ELSE
		-- 이미 폐기된것이지 확인
		SELECT COUNT(DisposeNo) INTO disposecnt FROM ScheduleResourcesDispose
		WHERE ResourceNo = ResourceNo
		
		IF DisposeCnt > 0 THEN
			RETURN QUERY
			SELECT 2 AS RC
		END IF;
		ELSE
			RETURN QUERY
			SELECT 0 AS RC
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
