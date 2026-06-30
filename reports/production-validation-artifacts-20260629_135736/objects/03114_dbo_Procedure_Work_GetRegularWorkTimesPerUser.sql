-- ─── PROCEDURE→FUNCTION: work_getregularworktimesperuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.work_getregularworktimesperuser(integer, date, date);
CREATE OR REPLACE FUNCTION public.work_getregularworktimesperuser(
    IN groupno integer,
    IN startdate date,
    IN enddate date
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT *,
		(SELECT /* TOP 1 */ RWJ.CreationDate
		 FROM RegularWorkJournals RWJ
		 WHERE RWJ.RegUserNo = T.UserNo AND RWJ.GroupNo = work_getregularworktimesperuser.groupno
		 ORDER BY RWJ.CreationDate DESC) AS LastCreationDate
	FROM (
		SELECT CONVERT(INT, ROW_NUMBER() OVER (ORDER BY T.WorkTime DESC)) AS RowNum,
			U.UserNo, U.Name AS UserName, P.Name AS PositionName, D.Name AS DepartName,
			T.WorkTime
		FROM (
			SELECT RWJ.RegUserNo, SUM(RWJ.WorkTime) AS WorkTime
			FROM RegularWorkJournals RWJ
			INNER JOIN RegularWorkGroups RWG ON RWG.GroupNo = RWJ.GroupNo
				AND RWG.GroupNo = work_getregularworktimesperuser.groupno
			WHERE (RWJ.CreationDate BETWEEN StartDate AND EndDate)
			GROUP BY RWJ.RegUserNo
		) T
		INNER JOIN Organization_Users U ON U.UserNo = T.RegUserNo AND U.Enabled = TRUE
		INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo and B.IsDefault = TRUE
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	) T;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
