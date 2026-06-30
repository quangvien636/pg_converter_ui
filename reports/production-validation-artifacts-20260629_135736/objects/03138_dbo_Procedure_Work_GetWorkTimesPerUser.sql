-- ─── PROCEDURE→FUNCTION: work_getworktimesperuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.work_getworktimesperuser(integer, date, date);
CREATE OR REPLACE FUNCTION public.work_getworktimesperuser(
    IN groupno integer,
    IN startdate date,
    IN enddate date
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT *,
		(SELECT /* TOP 1 */ WJ.CreationDate
		 FROM WorkJournals WJ
		 INNER JOIN WorkGroups WG ON WG.GroupNo = work_getworktimesperuser.groupno
		 INNER JOIN Works W ON W.GroupNo = WG.GroupNo AND W.WorkNo = WJ.WorkNo
		 WHERE WJ.RegUserNo = T.UserNo
		 ORDER BY WJ.CreationDate DESC) AS LastCreationDate
	FROM (
		SELECT CONVERT(INT, ROW_NUMBER() OVER (ORDER BY T.WorkTime DESC)) AS RowNum,
			U.UserNo, U.Name AS UserName, P.Name AS PositionName, D.Name AS DepartName,
			T.WorkTime
		FROM (
			SELECT WJ.RegUserNo, SUM(WJ.WorkTime) AS WorkTime
			FROM WorkJournals WJ
			INNER JOIN Works W ON W.WorkNo = WJ.WorkNo
			INNER JOIN WorkGroups WG ON WG.GroupNo = W.GroupNo AND WG.GroupNo = work_getworktimesperuser.groupno
			WHERE (WJ.CreationDate BETWEEN StartDate AND EndDate)
			GROUP BY WJ.RegUserNo
		) T
		INNER JOIN Organization_Users U ON U.UserNo = T.RegUserNo
		INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo and B.IsDefault = TRUE
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	) T;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
