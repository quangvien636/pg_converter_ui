-- ─── FUNCTION: work_getworkgroupspergroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getworkgroupspergroup(date, date, integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.work_getworkgroupspergroup(
    startdate date,
    enddate date,
    searchtype integer,
    searchtext character varying,
    viewcount integer,
    currentpageindex integer
) RETURNS TABLE(
    groupno text
)
AS $function$
BEGIN



		RowNum			INT,
		GroupNo			INT,
		GroupName		NVARCHAR(100),
		UserName		NVARCHAR(100),
		PositionName	NVARCHAR(100),
		RegDate			DATETIME,
		CompleteDate	DATETIME,
		WorkTime		INT
	)

	IF SearchType = 0 BEGIN

		INSERT INTO tbResult
		RETURN QUERY
		SELECT * FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY T.WorkTime DESC) AS RowNum,
				WG.GroupNo, WGH.Name AS GroupName,
				U.Name AS UserName, P.Name AS PositionName,
				WG.RegDate, WGH.CompleteDate, WorkTime
			FROM (
				SELECT WG.GroupNo, COALESCE(SUM(WJ.WorkTime), 0) AS WorkTime
				FROM WorkGroups WG
				LEFT JOIN Works W ON W.GroupNo = WG.GroupNo
				LEFT JOIN WorkJournals WJ ON WJ.WorkNo = W.WorkNo
					AND (WJ.CreationDate BETWEEN StartDate AND EndDate)
				WHERE WG.Enabled = TRUE
				GROUP BY WG.GroupNo
			) T
			INNER JOIN WorkGroups WG ON WG.GroupNo = T.GroupNo
			INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
			INNER JOIN Organization_Users U ON U.UserNo = WGH.UserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = WGH.UserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		) T
		WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
	
	END
	
	ELSE IF SearchType = 1 BEGIN
	
		INSERT INTO tbResult
		RETURN QUERY
		SELECT * FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY T.WorkTime DESC) AS RowNum,
				WG.GroupNo, WGH.Name AS GroupName,
				U.Name AS UserName, P.Name AS PositionName,
				WG.RegDate, WGH.CompleteDate, WorkTime
			FROM (
				SELECT WG.GroupNo, COALESCE(SUM(WJ.WorkTime), 0) AS WorkTime
				FROM WorkGroups WG
				INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
					AND WGH.Name ILIKE '%' || SearchText || '%'
				LEFT JOIN Works W ON W.GroupNo = WG.GroupNo
				LEFT JOIN WorkJournals WJ ON WJ.WorkNo = W.WorkNo
					AND (WJ.CreationDate BETWEEN StartDate AND EndDate)
				WHERE WG.Enabled = TRUE
				GROUP BY WG.GroupNo
			) T
			INNER JOIN WorkGroups WG ON WG.GroupNo = T.GroupNo
			INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
			INNER JOIN Organization_Users U ON U.UserNo = WGH.UserNo
			INNER JOIN Organization_BelongToDepartment B ON B.UserNo = WGH.UserNo and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		) T
		WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		
	END
	
	RETURN QUERY
	SELECT * FROM tbResult
	
	RETURN QUERY
	SELECT WG.GroupNo, SUM(WH.WorkTime) AS ExpectedTime
	FROM WorkGroups WG
	INNER JOIN Works W ON W.GroupNo = WG.GroupNo AND W.Enabled = TRUE
	INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
	WHERE WG.GroupNo IN (SELECT GroupNo FROM tbResult)
	GROUP BY WG.GroupNo
	
	RETURN QUERY
	SELECT WG.GroupNo, W.CompletionRate,
		CONVERT(INT, WH.WorkTime / CONVERT(FLOAT, 100) * W.CompletionRate) AS ProcessingTime,
		SUM(WJ.WorkTime) AS WorkTime
	FROM WorkJournals WJ
	INNER JOIN Works W ON W.WorkNo = WJ.WorkNo AND W.Enabled = TRUE
	INNER JOIN WorkHistorys WH ON WH.HistoryNo = W.HistoryNo
	INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo
		AND WG.GroupNo IN (SELECT GroupNo FROM tbResult)
	GROUP BY WG.GroupNo, WH.WorkTime, W.CompletionRate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
