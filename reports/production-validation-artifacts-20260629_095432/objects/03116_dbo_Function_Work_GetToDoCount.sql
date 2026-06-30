-- ─── FUNCTION: work_gettodocount ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_gettodocount(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.work_gettodocount(
    userno integer,
    divisionno integer,
    searchtype integer
) RETURNS TABLE(
    userno text
)
AS $function$
BEGIN


	IF DivisionNo = 0 BEGIN
		
		IF SearchType = 0 BEGIN
		
			RETURN QUERY
			SELECT COUNT(*)
			FROM Works W
			INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo AND WG.Enabled = TRUE AND WG.State = 2
			INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
				AND(WH.UserNo = work_gettodocount.userno OR W.HistoryNo IN (SELECT HistoryNo FROM WorkAssistants
														   WHERE UserNo = work_gettodocount.userno)
					OR (WH.IsEveryPerson = TRUE AND UserNo IN (SELECT UserNo FROM WorkGroupPersons
		                                                     WHERE GroupNo = WG.GroupNo))
		        )
			WHERE W.Enabled = TRUE AND W.FinalDate IS NULL
														  
		END
		
		ELSE IF SearchType = 1 BEGIN
		
			RETURN QUERY
			SELECT COUNT(*)
			FROM Works W
			INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo AND WG.Enabled = TRUE AND WG.State = 2
			INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
				AND (WH.UserNo = work_gettodocount.userno OR W.HistoryNo IN (SELECT HistoryNo FROM WorkAssistants
														    WHERE UserNo = work_gettodocount.userno)
					OR (WH.IsEveryPerson = TRUE AND UserNo IN (SELECT UserNo FROM WorkGroupPersons
		                                                     WHERE GroupNo = WG.GroupNo))
		        )
				AND WH.Title ILIKE '%' || SearchText || '%'
			WHERE W.Enabled = TRUE AND W.FinalDate IS NULL
				
		END
		
	END
	
	ELSE BEGIN
		
		IF SearchType = 0 BEGIN
		
			RETURN QUERY
			SELECT COUNT(*)
			FROM Works W
			INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo AND WG.Enabled = TRUE AND WG.State = 2
			INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
				AND WH.DivisionNo = work_gettodocount.divisionno
				AND (WH.UserNo = work_gettodocount.userno OR W.HistoryNo IN (SELECT HistoryNo FROM WorkAssistants
														    WHERE UserNo = work_gettodocount.userno)
					OR (WH.IsEveryPerson = TRUE AND UserNo IN (SELECT UserNo FROM WorkGroupPersons
		                                                     WHERE GroupNo = WG.GroupNo))
		        )
			WHERE W.Enabled = TRUE AND W.FinalDate IS NULL
														    				
		END
		
		ELSE IF SearchType = 1 BEGIN
		
			RETURN QUERY
			SELECT COUNT(*)
			FROM Works W
			INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo AND WG.Enabled = TRUE AND WG.State = 2
			INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
				AND WH.DivisionNo = work_gettodocount.divisionno
				AND (WH.UserNo = work_gettodocount.userno OR W.HistoryNo IN (SELECT HistoryNo FROM WorkAssistants
														    WHERE UserNo = work_gettodocount.userno)
					OR (WH.IsEveryPerson = TRUE AND UserNo IN (SELECT UserNo FROM WorkGroupPersons
		                                                     WHERE GroupNo = WG.GroupNo))
		        )
				AND WH.Title ILIKE '%' || SearchText || '%'
			WHERE W.Enabled = TRUE AND W.FinalDate IS NULL
				
		END
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
