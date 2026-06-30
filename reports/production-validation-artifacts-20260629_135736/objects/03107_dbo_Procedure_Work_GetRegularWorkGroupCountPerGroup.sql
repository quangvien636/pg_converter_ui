-- ─── PROCEDURE→FUNCTION: work_getregularworkgroupcountpergroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getregularworkgroupcountpergroup(integer, integer);
CREATE OR REPLACE FUNCTION public.work_getregularworkgroupcountpergroup(
    IN divisionno integer,
    IN searchtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF DivisionNo = 0 THEN
		
		IF SearchType = 0 THEN
				
			RETURN QUERY
			SELECT COUNT(*)
			FROM RegularWorkGroups RWG
			WHERE RWG.Enabled = TRUE
		
		END IF;
			
		ELSIF SearchType = 1 THEN
			
			RETURN QUERY
			SELECT COUNT(*)
			FROM RegularWorkGroups RWG
			INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
			WHERE RWG.Enabled = TRUE AND RWGH.Name ILIKE '%' || SearchText || '%'
				
		END IF;
		
	END IF;
	
	ELSE BEGIN
	
		IF SearchType = 0 THEN
			
			RETURN QUERY
			SELECT COUNT(*)
			FROM RegularWorkGroups RWG
			INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
			WHERE RWG.Enabled = TRUE AND RWGH.DivisionNo = work_getregularworkgroupcountpergroup.divisionno
	
		END IF;
		
		ELSIF SearchType = 1 THEN
		
			RETURN QUERY
			SELECT COUNT(*)
			FROM RegularWorkGroups RWG
			INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
			WHERE RWG.Enabled = TRUE AND RWGH.DivisionNo = work_getregularworkgroupcountpergroup.divisionno
				AND RWGH.Name ILIKE '%' || SearchText || '%'
			
		END IF;
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
