-- ─── PROCEDURE→FUNCTION: work_gettodocount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_gettodocount(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.work_gettodocount(
    IN userno integer,
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
			FROM Works W
			INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo AND WG.Enabled = TRUE AND WG.State = 2
			INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
				AND(WH.UserNo = work_gettodocount.userno OR W.HistoryNo IN (SELECT HistoryNo FROM WorkAssistants
														   WHERE UserNo = work_gettodocount.userno)
					OR (WH.IsEveryPerson = TRUE AND UserNo IN (SELECT UserNo FROM WorkGroupPersons
		                                                     WHERE GroupNo = WG.GroupNo))
		        )
			WHERE W.Enabled = TRUE AND W.FinalDate IS NULL
														  
		END IF;
		
		ELSIF SearchType = 1 THEN
		
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
				
		END IF;
		
	END IF;
	
	ELSE BEGIN
		
		IF SearchType = 0 THEN
		
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
														    				
		END IF;
		
		ELSIF SearchType = 1 THEN
		
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
				
		END IF;
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
