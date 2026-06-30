-- ─── FUNCTION: work_getregularworkgroupcountpergroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularworkgroupcountpergroup(integer, integer);
CREATE OR REPLACE FUNCTION public.work_getregularworkgroupcountpergroup(
    divisionno integer,
    searchtype integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	IF DivisionNo = 0 BEGIN
		
		IF SearchType = 0 BEGIN
				
			RETURN QUERY
			SELECT COUNT(*)
			FROM RegularWorkGroups RWG
			WHERE RWG.Enabled = TRUE
		
		END
			
		ELSE IF SearchType = 1 BEGIN
			
			RETURN QUERY
			SELECT COUNT(*)
			FROM RegularWorkGroups RWG
			INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
			WHERE RWG.Enabled = TRUE AND RWGH.Name ILIKE '%' || SearchText || '%'
				
		END
		
	END
	
	ELSE BEGIN
	
		IF SearchType = 0 BEGIN
			
			RETURN QUERY
			SELECT COUNT(*)
			FROM RegularWorkGroups RWG
			INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
			WHERE RWG.Enabled = TRUE AND RWGH.DivisionNo = work_getregularworkgroupcountpergroup.divisionno
	
		END
		
		ELSE IF SearchType = 1 BEGIN
		
			RETURN QUERY
			SELECT COUNT(*)
			FROM RegularWorkGroups RWG
			INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
			WHERE RWG.Enabled = TRUE AND RWGH.DivisionNo = work_getregularworkgroupcountpergroup.divisionno
				AND RWGH.Name ILIKE '%' || SearchText || '%'
			
		END
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
