-- ─── FUNCTION: work_getcooperationgroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getcooperationgroups(integer, boolean, boolean, boolean, boolean, boolean, integer, character varying, integer, integer, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.work_getcooperationgroups(
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
    groupno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    tbhistorynos table
	(
		historyno	int
	);
    tbgroupno table
	(
		groupno	int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	IF IsDirector = TRUE BEGIN
	
		INSERT INTO tbHistoryNos
		RETURN QUERY
		SELECT HistoryNo FROM WorkGroupAssistants WHERE UserNo = work_getcooperationgroups.userno
		
		INSERT INTO tbGroupNo
		RETURN QUERY
		select GroupNo from Works wa
		join WorkHistorys wc
		on wa.HistoryNo = wc.HistoryNo
		left join WorkAssistants wb
		on wa.HistoryNo = wb.HistoryNo
		where wb.UserNo = work_getcooperationgroups.userno or wc.UserNo = work_getcooperationgroups.userno
	
	END

	RETURN QUERY
	SELECT * FROM (
		SELECT
			ROW_NUMBER() OVER
			(
				ORDER BY
				CooperationModDate DESC , CooperationCount DESC,
				(CASE WHEN SortColumn = 'GroupName' AND SortOrder = 'ASC' THEN T.GroupName END) ASC,
				(CASE WHEN SortColumn = 'GroupName' AND SortOrder = 'DESC' THEN T.GroupName END) DESC,
				(CASE WHEN SortColumn = 'UserName' AND SortOrder = 'ASC' THEN T.UserName END) ASC,
				(CASE WHEN SortColumn = 'UserName' AND SortOrder = 'DESC' THEN T.UserName END) DESC,
				(CASE WHEN SortColumn = 'RegDate' AND SortOrder = 'ASC' THEN T.RegDate END) ASC,
				(CASE WHEN SortColumn = 'RegDate' AND SortOrder = 'DESC' THEN T.RegDate END) DESC,
				(CASE WHEN SortColumn = 'CompleteDate' AND SortOrder = 'ASC' THEN T.CompleteDate END) ASC,
				(CASE WHEN SortColumn = 'CompleteDate' AND SortOrder = 'DESC' THEN T.CompleteDate END) DESC
			) AS RowNum,
			*
		FROM
		(
			SELECT
				W.GroupNo, H.Name AS GroupName, U.Name AS UserName, P.Name AS PositionName,
				W.RegDate, H.RegDate AS ModDate
				,(select count(*) from Work_Cooperation c where c.GroupNo = W.GroupNo) as CooperationCount
				,(select count(*) from Work_Cooperation A left join Work_CooperationReference B 
					on A.CooperationNo = B.CooperationNo and B.UserNo = work_getcooperationgroups.userno
					where A.GroupNo = W.GroupNo and COALESCE(B.UserNo,0) != work_getcooperationgroups.userno) as UnreadCooperationCount

				,(select count(*) from Work_CooperationComments c where c.GroupNo = W.GroupNo) as CooperationCommentCount
				,(select count(*) from Work_CooperationComments A left join Work_CooperationCommentReference B 
					on A.CommentNo = B.CommentNo and B.UserNo = work_getcooperationgroups.userno
					where A.GroupNo = W.GroupNo and COALESCE(B.UserNo,0) != work_getcooperationgroups.userno) as UnreadCooperationCommentCount,

				(select /* TOP 1 */ ModDate from Work_Cooperation c where c.GroupNo = W.GroupNo order by ModDate desc) as CooperationModDate,
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
					OR (IsDirector = TRUE AND (H.UserNo = work_getcooperationgroups.userno OR H.HistoryNo IN (SELECT HistoryNo FROM tbHistoryNos)))
					OR (IsDirector = TRUE AND 
					(
						W.GroupNo IN (SELECT GroupNo FROM tbGroupNo))
					)
				) 
				AND 
				(
					IsComplete = TRUE AND H.CompleteDate <= CONVERT(CHAR(10), NOW(), 23)
					OR 
					IsComplete = FALSE AND H.CompleteDate >= CONVERT(CHAR(10), NOW(), 23)
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
							OR (W.State = 20)
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
