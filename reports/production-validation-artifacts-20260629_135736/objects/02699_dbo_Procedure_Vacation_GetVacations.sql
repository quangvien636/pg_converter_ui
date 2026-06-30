-- ─── PROCEDURE→FUNCTION: vacation_getvacations ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_getvacations(integer, integer, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_getvacations(
    IN p_index integer,
    IN p_viewcount integer,
    IN p_uname character varying DEFAULT '',
    IN p_dename character varying DEFAULT '',
    IN p_lang character varying DEFAULT 'KO',
    IN p_from character varying DEFAULT '',
    IN p_to character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


RETURN QUERY
SELECT * FROM (
				SELECT 
					ROW_NUMBER() OVER(ORDER BY COALESCE(S.SortNo,99999) ASC, P.SortNo ASC, DT.SortNo ASC, U.Name ASC) AS RowNum
					, pTotal = COUNT(*) OVER()
					, pIndex = vacation_getvacations.p_index
					, pSize = vacation_getvacations.p_viewcount
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
					, V.Vacations
					, V.Used
					, V.Note 
				FROM Organization_BelongToDepartment B 
				INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
				INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
				INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
				LEFT JOIN Organization_Duties DT  ON DT.DutyNo = B.DutyNo
				LEFT JOIN Organization_SortingEachDepartment S ON S.UserNo = U.UserNo 
				LEFT JOIN Vacation_Vacations V ON V.UserNo =  U.UserNo
				WHERE B.IsDefault = TRUE
				AND (p_UName = '' OR LOWER(U.Name) ILIKE '%' || p_UName || '%' OR LOWER(U.UserID) ILIKE '%' || p_UName || '%')
				AND (p_DeName = '' OR LOWER(D.Name) ILIKE '%' || p_DeName || '%')
				AND (p_from = '' OR V.DateCreate between p_from and p_to)
			) X  WHERE X.RowNum BETWEEN ((p_Index - 1) * p_ViewCount) + 1  AND (p_Index * p_ViewCount)
			order by X.RowNum;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
