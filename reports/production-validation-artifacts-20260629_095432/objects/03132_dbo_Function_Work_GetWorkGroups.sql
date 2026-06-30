-- ─── FUNCTION: work_getworkgroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getworkgroups(integer, boolean, boolean, boolean, boolean, boolean, integer, character varying, integer, integer, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.work_getworkgroups(
    userno integer,
    isprogress boolean,
    iscomplete boolean,
    ispending boolean,
    ispause boolean,
    isdelete boolean,
    searchtype integer,
    searchtext character varying,
    viewcount integer,
    currentpageindex integer,
    sortcolumn character varying,
    sortorder character varying,
    ismanager boolean
) RETURNS TABLE(
    historyno text
)
AS $function$
DECLARE
    tbhistorynos table
	(
		historyno	int
	);
BEGIN



	IF IsDirector = TRUE BEGIN
	
		INSERT INTO tbHistoryNos
		RETURN QUERY
		SELECT HistoryNo FROM WorkGroupAssistants WHERE UserNo = work_getworkgroups.userno
	
	END

	RETURN QUERY
	SELECT * FROM (
		SELECT
			ROW_NUMBER() OVER
			(
				ORDER BY
				(CASE WHEN SortColumn = 'GroupName' AND SortOrder = 'ASC' THEN T.GroupName END) ASC,
				(CASE WHEN SortColumn = 'GroupName' AND SortOrder = 'DESC' THEN T.GroupName END) DESC,
				(CASE WHEN SortColumn = 'UserName' AND SortOrder = 'ASC' THEN T.UserName END) ASC,
				(CASE WHEN SortColumn = 'UserName' AND SortOrder = 'DESC' THEN T.UserName END) DESC,
				(CASE WHEN SortColumn = 'RegDate' AND SortOrder = 'ASC' THEN T.RegDate END) ASC,
				(CASE WHEN SortColumn = 'RegDate' AND SortOrder = 'DESC' THEN T.RegDate END) DESC,
				(CASE WHEN SortColumn = 'ExpectedTime' AND SortOrder = 'ASC' THEN T.ExpectedTime END) ASC,
				(CASE WHEN SortColumn = 'ExpectedTime' AND SortOrder = 'DESC' THEN T.ExpectedTime END) DESC,
				(CASE WHEN SortColumn = 'WorkTime' AND SortOrder = 'ASC' THEN T.WorkTime END) ASC,
				(CASE WHEN SortColumn = 'WorkTime' AND SortOrder = 'DESC' THEN T.WorkTime END) DESC,
				(CASE WHEN SortColumn = 'CompleteDate' AND SortOrder = 'ASC' THEN T.CompleteDate END) ASC,
				(CASE WHEN SortColumn = 'CompleteDate' AND SortOrder = 'DESC' THEN T.CompleteDate END) DESC
			) AS RowNum,
			*,
			CONVERT(INT, COALESCE(
				CASE
					WHEN T.ProcessingTime = 0 AND T.ExpectedTime = 0 THEN 0
					ELSE (T.ProcessingTime / CONVERT(FLOAT, T.ExpectedTime)) * 100
				END
			, 0)) AS CompletionRate
		FROM
		(
			SELECT
				W.GroupNo, H.Name AS GroupName, U.Name AS UserName, P.Name AS PositionName,
				W.RegDate, H.RegDate AS ModDate,
				
				COALESCE(
					(SELECT SUM(WH2.WorkTime)
					FROM WorkGroups WG2
					INNER JOIN Works W2 ON W2.GroupNo = WG2.GroupNo AND W2.Enabled = TRUE
					INNER JOIN WorkHistorys WH2 ON WH2.HistoryNo = W2.HistoryNo
					WHERE WG2.GroupNo = W.GroupNo GROUP BY WG2.GroupNo)
				,0) AS ExpectedTime,
				
				COALESCE(
					(SELECT SUM(T.ProcessingTime)
					FROM
					(
						SELECT
							CONVERT(INT, WH2.WorkTime / CONVERT(FLOAT, 100) * W2.CompletionRate) AS ProcessingTime
						FROM Works W2
						INNER JOIN WorkHistorys WH2 ON WH2.HistoryNo = W2.HistoryNo
						INNER JOIN WorkGroups WG2 ON WG2.GroupNo = W2.GroupNo AND WG2.GroupNo = W.GroupNo
						WHERE W2.Enabled = TRUE
						GROUP BY WG2.GroupNo, W2.WorkNo, WH2.WorkTime, W2.CompletionRate
					) T )
				,0) AS ProcessingTime,
				
				COALESCE(
					(SELECT SUM(T.WorkTime)
					FROM
					(
						SELECT SUM(WJ2.WorkTime) AS WorkTime
						FROM WorkJournals WJ2
						INNER JOIN Works W2 ON W2.WorkNo = WJ2.WorkNo AND W2.Enabled = TRUE
						INNER JOIN WorkGroups WG2 ON WG2.GroupNo = W2.GroupNo AND WG2.GroupNo = W.GroupNo
						GROUP BY WG2.GroupNo, W2.WorkNo
					) T )
				, 0) AS WorkTime,
				
				H.CompleteDate, W.IsLock, W.State, W.FinalDate, W.Enabled
			FROM WorkGroups W
			INNER JOIN WorkGroupHistorys H ON H.HistoryNo = W.HistoryNo
				AND
				(
					SearchType = 0
					OR (SearchType = 1 AND H.Name ILIKE '%' || SearchText || '%')
				)
			INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
			WHERE
				(
					IsManager = TRUE
					OR (IsDirector = TRUE AND (H.UserNo = work_getworkgroups.userno OR H.HistoryNo IN (SELECT HistoryNo FROM tbHistoryNos)))
				)
				AND
				(
					(
						W.Enabled = TRUE AND
						(
							(IsProgress = TRUE AND W.State = 2)
							OR (IsComplete = TRUE AND W.State = 1)
							OR (IsPending = TRUE AND W.State = 3)
							OR (IsPause = TRUE AND W.State = 4)
						)
					)
					OR (IsDelete = TRUE AND W.Enabled = FALSE)
				)
		) AS T
	) AS T2
	WHERE T2.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
