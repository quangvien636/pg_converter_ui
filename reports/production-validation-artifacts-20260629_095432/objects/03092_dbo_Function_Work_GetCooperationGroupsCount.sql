-- ─── FUNCTION: work_getcooperationgroupscount ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getcooperationgroupscount(integer, boolean, boolean, boolean, boolean, boolean, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.work_getcooperationgroupscount(
    userno integer,
    isprogress boolean,
    iscomplete boolean,
    ispending boolean,
    ispause boolean,
    isdelete boolean,
    searchtype integer,
    searchtext character varying,
    ismanager boolean
) RETURNS TABLE(
    groupno text
)
AS $function$
BEGIN


	IF IsManager = TRUE BEGIN

		IF SearchType = 0 BEGIN
	
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
					OR (W.State = 20)
					)
				)
				OR (IsDelete = TRUE AND W.Enabled = FALSE)
		
		END
		
		ELSE IF SearchType = 1 BEGIN
		
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
					OR (W.State = 20)
					)
				)
				OR (IsDelete = TRUE AND W.Enabled = FALSE)
			
		END

	END
	
	ELSE IF IsDirector = TRUE BEGIN
	
		IF SearchType = 0 BEGIN
	
			RETURN QUERY
			SELECT COUNT(*)
			FROM WorkGroups W
			INNER JOIN WorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
			INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
			WHERE (H.UserNo = work_getcooperationgroupscount.userno OR H.HistoryNo IN (SELECT HistoryNo FROM WorkGroupAssistants
													     WHERE UserNo = work_getcooperationgroupscount.userno)
					OR W.GroupNo in (select GroupNo from Works wa
					join WorkHistorys wc
					on wa.HistoryNo = wc.HistoryNo
					left join WorkAssistants wb
					on wa.HistoryNo = wb.HistoryNo
					where wb.UserNo = work_getcooperationgroupscount.userno or wc.UserNo = work_getcooperationgroupscount.userno)														 
				  )
				AND (
					W.Enabled = TRUE AND (
						(IsProgress = TRUE AND W.State = 2)
						OR (IsComplete = TRUE AND W.State = 1)
						OR (IsPending = TRUE AND W.State = 3)
						OR (IsPause = TRUE AND W.State = 4)
						OR (W.State = 20)
						)
					)
					OR (IsDelete = TRUE AND W.Enabled = FALSE)
		
		END
		
		ELSE IF SearchType = 1 BEGIN
		
			RETURN QUERY
			SELECT COUNT(*)
			FROM WorkGroups W
			INNER JOIN WorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
			INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
				AND H.Name ILIKE '%' || SearchText || '%'
			WHERE (H.UserNo = work_getcooperationgroupscount.userno OR H.HistoryNo IN (SELECT HistoryNo FROM WorkGroupAssistants
													     WHERE UserNo = work_getcooperationgroupscount.userno)
					OR W.GroupNo in (select GroupNo from Works wa
					join WorkHistorys wc
					on wa.HistoryNo = wc.HistoryNo
					left join WorkAssistants wb
					on wa.HistoryNo = wb.HistoryNo
					where wb.UserNo = work_getcooperationgroupscount.userno or wc.UserNo = work_getcooperationgroupscount.userno)														 
				  )
				AND (
					W.Enabled = TRUE AND (
						(IsProgress = TRUE AND W.State = 2)
						OR (IsComplete = TRUE AND W.State = 1)
						OR (IsPending = TRUE AND W.State = 3)
						OR (IsPause = TRUE AND W.State = 4)
						OR (W.State = 20)
						)
					)
					OR (IsDelete = TRUE AND W.Enabled = FALSE)
			
		END
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
