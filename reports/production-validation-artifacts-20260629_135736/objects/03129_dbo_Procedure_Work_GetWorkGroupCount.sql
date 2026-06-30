-- ─── PROCEDURE→FUNCTION: work_getworkgroupcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getworkgroupcount(integer, boolean, boolean, boolean, boolean, boolean, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.work_getworkgroupcount(
    IN userno integer,
    IN isprogress boolean,
    IN iscomplete boolean,
    IN ispending boolean,
    IN ispause boolean,
    IN isdelete boolean,
    IN searchtype integer,
    IN searchtext character varying,
    IN ismanager boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF IsManager = TRUE THEN

		IF SearchType = 0 THEN
	
			RETURN QUERY
			SELECT COUNT(*)
			FROM WorkGroups W
			INNER JOIN WorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
			INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
			WHERE (
				W.Enabled = TRUE AND (
					(IsProgress = TRUE AND W.State = 2)
					OR (IsComplete = TRUE AND W.State = 1)
					OR (IsPending = TRUE AND W.State = 3)
					OR (IsPause = TRUE AND W.State = 4)
					)
				)
				OR (IsDelete = TRUE AND W.Enabled = FALSE)
		
		END IF;
		
		ELSIF SearchType = 1 THEN
		
			RETURN QUERY
			SELECT COUNT(*)
			FROM WorkGroups W
			INNER JOIN WorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
			INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
				AND H.Name ILIKE '%' || SearchText || '%'
			WHERE (
				W.Enabled = TRUE AND (
					(IsProgress = TRUE AND W.State = 2)
					OR (IsComplete = TRUE AND W.State = 1)
					OR (IsPending = TRUE AND W.State = 3)
					OR (IsPause = TRUE AND W.State = 4)
					)
				)
				OR (IsDelete = TRUE AND W.Enabled = FALSE)
			
		END IF;

	END IF;
	
	ELSIF IsDirector = TRUE THEN
	
		IF SearchType = 0 THEN
	
			RETURN QUERY
			SELECT COUNT(*)
			FROM WorkGroups W
			INNER JOIN WorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
			INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
			WHERE (H.UserNo = work_getworkgroupcount.userno OR H.HistoryNo IN (SELECT HistoryNo FROM WorkGroupAssistants
													     WHERE UserNo = work_getworkgroupcount.userno))
				AND (
					W.Enabled = TRUE AND (
						(IsProgress = TRUE AND W.State = 2)
						OR (IsComplete = TRUE AND W.State = 1)
						OR (IsPending = TRUE AND W.State = 3)
						OR (IsPause = TRUE AND W.State = 4)
						)
					)
					OR (IsDelete = TRUE AND W.Enabled = FALSE)
		
		END IF;
		
		ELSIF SearchType = 1 THEN
		
			RETURN QUERY
			SELECT COUNT(*)
			FROM WorkGroups W
			INNER JOIN WorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
			INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
				AND H.Name ILIKE '%' || SearchText || '%'
			WHERE (H.UserNo = work_getworkgroupcount.userno OR H.HistoryNo IN (SELECT HistoryNo FROM WorkGroupAssistants
													     WHERE UserNo = work_getworkgroupcount.userno))
				AND (
					W.Enabled = TRUE AND (
						(IsProgress = TRUE AND W.State = 2)
						OR (IsComplete = TRUE AND W.State = 1)
						OR (IsPending = TRUE AND W.State = 3)
						OR (IsPause = TRUE AND W.State = 4)
						)
					)
					OR (IsDelete = TRUE AND W.Enabled = FALSE)
			
		END IF;
	
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
