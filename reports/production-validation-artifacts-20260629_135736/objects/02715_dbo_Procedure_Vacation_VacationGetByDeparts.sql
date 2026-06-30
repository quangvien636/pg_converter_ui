-- ─── PROCEDURE→FUNCTION: vacation_vacationgetbydeparts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_vacationgetbydeparts(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.vacation_vacationgetbydeparts(
    IN p_index integer,
    IN p_viewcount integer,
    IN p_dno integer,
    IN p_y integer,
    IN p_lang character varying DEFAULT 'KO',
    IN p_from character varying DEFAULT '',
    IN p_to character varying DEFAULT '',
    IN p_uid character varying DEFAULT '',
    IN p_uname character varying DEFAULT '',
    IN p_show boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	--declare p_year int = Year(NOW());
	--declare p_fistday date = cast(p_year as varchar(4)) + '-01'+'-01';
	RETURN QUERY
	SELECT * 
	FROM (
			SELECT 
				ROW_NUMBER() OVER(ORDER BY COALESCE(S.SortNo,99999) ASC, P.SortNo ASC, DT.SortNo ASC, U.Name ASC) AS RowNum
				, pTotal = COUNT(*) OVER()
				, pIndex = vacation_vacationgetbydeparts.p_index
				, pSize = vacation_vacationgetbydeparts.p_viewcount
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
				, X2.Addition1 -- 
				, X2.Addition2
				, V.Note 
				, V.statusr
			FROM  (
					SELECT min(DepartNo) DepartNo, min(PositionNo) PositionNo, min(DutyNo) DutyNo, UserNo 
					FROM Organization_BelongToDepartment 
					WHERE (p_dno = 0  or DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(p_dno, 0)))
					GROUP BY UserNo) B
			INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo AND (U.Enabled = TRUE OR  p_show = 0) AND U.IsVirtual = FALSE
			LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
			LEFT JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
			LEFT JOIN Organization_SortingEachDepartment S ON S.UserNo = B.UserNo and S.DepartNo = vacation_vacationgetbydeparts.p_dno
			LEFT JOIN Organization_Duties DT  ON DT.DutyNo = B.DutyNo
			--LEFT JOIN( select s1.UserNo, max(s1.SortNo) as SortNo from Organization_SortingEachDepartment s1 group by s1.UserNo) S ON S.UserNo = U.UserNo 
			LEFT JOIN Vacation_Vacations V ON V.UserNo =  U.UserNo AND (V.years = vacation_vacationgetbydeparts.p_y)
			LEFT JOIN Vacation_Sum X2 ON u.UserNo =  x2.UsernoI AND X2.YEARS =  vacation_vacationgetbydeparts.p_y
			LEFT JOIN Vacation_SumRequest X3 ON u.UserNo =  X3.UserNo and x3.years = vacation_vacationgetbydeparts.p_y
			WHERE --(p_dno = 0  or B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(p_dno, 0)))
				
			--AND 
			(p_from = '' OR V.DateCreate between p_from and p_to)
			AND (p_uid = '' OR u.UserID ILIKE '%' || p_uid || '%')
			AND (p_uname = '' OR u.Name ILIKE '%' || p_uname || '%')
		) X  WHERE X.RowNum BETWEEN ((p_Index - 1) * p_ViewCount) + 1  AND (p_Index * p_ViewCount)
		order by X.RowNum;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
