-- ─── FUNCTION: work_getregularworkgroupcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularworkgroupcount(integer, integer, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.work_getregularworkgroupcount(
    userno integer,
    divisionno integer,
    searchtype integer,
    searchtext character varying,
    ismanager boolean
) RETURNS TABLE(
    historyno text
)
AS $function$
BEGIN


	IF IsManager = TRUE BEGIN
		
		IF DivisionNo = 0 BEGIN
	
			IF SearchType = 0 BEGIN
				
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				WHERE W.Enabled = TRUE
		
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.Name ILIKE '%' || SearchText || '%'
				
			END
		
		END
		
		ELSE BEGIN
		
			IF SearchType = 0 BEGIN
				
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.DivisionNo = work_getregularworkgroupcount.divisionno
		
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.DivisionNo = work_getregularworkgroupcount.divisionno AND H.Name ILIKE '%' || SearchText || '%'
				
			END
			
		END
		
	END

	ELSE IF IsDirector = TRUE BEGIN
	
		IF DivisionNo = 0 BEGIN
		
			IF SearchType = 0 BEGIN
		
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.UserNo = work_getregularworkgroupcount.userno
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.UserNo = work_getregularworkgroupcount.userno AND H.Name ILIKE '%' || SearchText || '%'
			
			END
		
		END
		
		ELSE BEGIN
		
			IF SearchType = 0 BEGIN
		
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.UserNo = work_getregularworkgroupcount.userno AND H.DivisionNo = work_getregularworkgroupcount.divisionno
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.UserNo = work_getregularworkgroupcount.userno AND H.DivisionNo = work_getregularworkgroupcount.divisionno AND H.Name ILIKE '%' || SearchText || '%'
			
			END
			
		END
		
	END
	
	ELSE IF IsPerson = TRUE BEGIN
	
		IF DivisionNo = 0 BEGIN
		
			IF SearchType = 0 BEGIN
		
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE
						AND (H.IsEveryPerson = TRUE OR H.HistoryNo IN (
							SELECT HistoryNo FROM RegularWorkGroupPersons WHERE UserNo = work_getregularworkgroupcount.userno))
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE
						AND (H.IsEveryPerson = TRUE OR H.HistoryNo IN (
							SELECT HistoryNo FROM RegularWorkGroupPersons WHERE UserNo = work_getregularworkgroupcount.userno))
						AND H.Name ILIKE '%' || SearchText || '%'
				
			END
		
		END
		
		ELSE BEGIN
		
			IF SearchType = 0 BEGIN
		
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupPersons RWGP ON RWGP.UserNo = work_getregularworkgroupcount.userno
					AND RWGP.HistoryNo = W.HistoryNo
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE
						AND (H.IsEveryPerson = TRUE OR H.HistoryNo IN (
							SELECT HistoryNo FROM RegularWorkGroupPersons WHERE UserNo = work_getregularworkgroupcount.userno))
						AND H.DivisionNo = work_getregularworkgroupcount.divisionno
			
			END
			
			ELSE IF SearchType = 1 BEGIN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupPersons RWGP ON RWGP.UserNo = work_getregularworkgroupcount.userno
					AND RWGP.HistoryNo = W.HistoryNo
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE
						AND (H.IsEveryPerson = TRUE OR H.HistoryNo IN (
							SELECT HistoryNo FROM RegularWorkGroupPersons WHERE UserNo = work_getregularworkgroupcount.userno))
						AND H.DivisionNo = work_getregularworkgroupcount.divisionno AND H.Name ILIKE '%' || SearchText || '%'
				
			END
		
		END
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
