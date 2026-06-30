-- ─── PROCEDURE→FUNCTION: work_getregularworkgroupcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getregularworkgroupcount(integer, integer, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.work_getregularworkgroupcount(
    IN userno integer,
    IN divisionno integer,
    IN searchtype integer,
    IN searchtext character varying,
    IN ismanager boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF IsManager = TRUE THEN
		
		IF DivisionNo = 0 THEN
	
			IF SearchType = 0 THEN
				
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				WHERE W.Enabled = TRUE
		
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.Name ILIKE '%' || SearchText || '%'
				
			END IF;
		
		END IF;
		
		ELSE BEGIN
		
			IF SearchType = 0 THEN
				
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.DivisionNo = work_getregularworkgroupcount.divisionno
		
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.DivisionNo = work_getregularworkgroupcount.divisionno AND H.Name ILIKE '%' || SearchText || '%'
				
			END IF;
			
		END IF;
		
	END;

	ELSIF IsDirector = TRUE THEN
	
		IF DivisionNo = 0 THEN
		
			IF SearchType = 0 THEN
		
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.UserNo = work_getregularworkgroupcount.userno
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.UserNo = work_getregularworkgroupcount.userno AND H.Name ILIKE '%' || SearchText || '%'
			
			END IF;
		
		END IF;
		
		ELSE BEGIN
		
			IF SearchType = 0 THEN
		
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.UserNo = work_getregularworkgroupcount.userno AND H.DivisionNo = work_getregularworkgroupcount.divisionno
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE AND H.UserNo = work_getregularworkgroupcount.userno AND H.DivisionNo = work_getregularworkgroupcount.divisionno AND H.Name ILIKE '%' || SearchText || '%'
			
			END IF;
			
		END IF;
		
	END;
	
	ELSIF IsPerson = TRUE THEN
	
		IF DivisionNo = 0 THEN
		
			IF SearchType = 0 THEN
		
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE
						AND (H.IsEveryPerson = TRUE OR H.HistoryNo IN (
							SELECT HistoryNo FROM RegularWorkGroupPersons WHERE UserNo = work_getregularworkgroupcount.userno))
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
				RETURN QUERY
				SELECT COUNT(*)
				FROM RegularWorkGroups W
				INNER JOIN RegularWorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				WHERE W.Enabled = TRUE
						AND (H.IsEveryPerson = TRUE OR H.HistoryNo IN (
							SELECT HistoryNo FROM RegularWorkGroupPersons WHERE UserNo = work_getregularworkgroupcount.userno))
						AND H.Name ILIKE '%' || SearchText || '%'
				
			END IF;
		
		END IF;
		
		ELSE BEGIN
		
			IF SearchType = 0 THEN
		
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
			
			END IF;
			
			ELSIF SearchType = 1 THEN
			
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
				
			END IF;
		
		END IF;
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
