-- ─── FUNCTION: work_getregularworktimesperuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularworktimesperuser(integer, date, date);
CREATE OR REPLACE FUNCTION public.work_getregularworktimesperuser(
    groupno integer,
    startdate date,
    enddate date
) RETURNS TABLE(
    reguserno text,
    worktime text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
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
