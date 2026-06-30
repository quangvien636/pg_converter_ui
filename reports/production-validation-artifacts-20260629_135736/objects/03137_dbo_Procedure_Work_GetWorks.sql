-- ─── PROCEDURE→FUNCTION: work_getworks ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getworks(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.work_getworks(
    IN userno integer,
    IN groupno integer,
    IN viewcount integer,
    IN currentpageindex integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	,
		DivisionName	NVARCHAR(100),
		UserName		NVARCHAR(100),
		PositionName	NVARCHAR(100),
		DepartName		NVARCHAR(100),
		RegDate			DATETIME,
		ModDate			DATETIME,
		WorkTime		INT,
		CompleteDate	DATETIME,
		Enabled		BIT
	)

	INSERT INTO tbResult
	RETURN QUERY
	SELECT * FROM (
		SELECT ROW_NUMBER() OVER (ORDER BY W.CompletionRate ASC) AS RowNum,
			W.WorkNo, W.CompletionRate, W.FinalDate, H.Title, WD.Name AS DivisionName,
			U.Name AS UserName, P.Name AS PositionName, D.Name AS DepartName,
			W.RegDate, H.RegDate AS ModDate, H.WorkTime, H.CompleteDate, W.Enabled
		FROM Works W
		INNER JOIN WorkHistorys H ON H.HistoryNo = W.HistoryNo
		INNER JOIN WorkDivisions WD ON WD.DivisionNo = H.DivisionNo
		INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
		INNER JOIN Organization_BelongToDepartment B ON B.UserNo = H.UserNo and B.IsDefault = TRUE
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
		WHERE W.GroupNo = work_getworks.groupno AND W.Enabled = TRUE
	) AS T
	WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
		AND CurrentPageIndex * ViewCount

	RETURN QUERY
	SELECT * FROM tbResult
	
	RETURN QUERY
	SELECT WJ.WorkNo, SUM(WJ.WorkTime) AS WorkTime
	FROM WorkJournals WJ
	INNER JOIN Works W ON W.WorkNo = WJ.WorkNo
	WHERE W.WorkNo IN (SELECT WorkNo FROM tbResult)
	GROUP BY WJ.WorkNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
