-- ─── FUNCTION: vacation_vacationgetbymys ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_vacationgetbymys(integer, integer, integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.vacation_vacationgetbymys(
    p_index integer,
    p_viewcount integer,
    p_dno integer,
    p_y integer,
    p_uno integer,
    p_lang character varying DEFAULT 'KO'
) RETURNS TABLE(
    col1 text,
    col2 text,
    col3 text,
    userno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT * 
	FROM (
			SELECT 
				ROW_NUMBER() OVER(ORDER BY U.Name ASC) AS RowNum
				, pTotal = COUNT(*) OVER()
				, pIndex = vacation_vacationgetbymys.p_index
				, pSize = vacation_vacationgetbymys.p_viewcount
				, COALESCE(v.VacationId,0) VacationId
				, B.UserNo
				, U.UserID
				, U.Name
				, D.DepartNo
				, D.Name AS DepartName
				, D.SortNo AS DepartSortNo
				, P.PositionNo
				, P.Name AS PositionName
				, P.SortNo AS PositionSortNo
				, COALESCE(V.Vacations,0)  AS Vacations
				, COALESCE(V.USED,0) PreUsed
				, COALESCE(X3.Used,0) + COALESCE(V.USED,0) AS Used
				, COALESCE(x3.Used1,0) Used1
				, COALESCE(x3.Used2,0) Used2
				, X2.Addition1
				, X2.Addition2
				, V.Note 
				, V.statusr
			FROM  (
					SELECT min(DepartNo) DepartNo, min(PositionNo) PositionNo, min(DutyNo) DutyNo, UserNo 
					FROM Organization_BelongToDepartment 
					WHERE UserNo = vacation_vacationgetbymys.p_uno
					GROUP BY UserNo) B
			INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo 
			LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
			LEFT JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
			LEFT JOIN Organization_Duties DT  ON DT.DutyNo = B.DutyNo
			LEFT JOIN Vacation_Vacations V ON V.UserNo =  U.UserNo AND (V.years = vacation_vacationgetbymys.p_y)
			LEFT JOIN Vacation_Sum X2 ON u.UserNo =  x2.UsernoI AND X2.YEARS =  vacation_vacationgetbymys.p_y
			LEFT JOIN Vacation_SumRequest X3 ON u.UserNo =  X3.UserNo and x3.years = vacation_vacationgetbymys.p_y
		) X  WHERE X.RowNum BETWEEN ((p_Index - 1) * p_ViewCount) + 1  AND (p_Index * p_ViewCount)
		order by X.RowNum;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
