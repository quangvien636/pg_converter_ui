-- ─── PROCEDURE→FUNCTION: workingtimev3_getusers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtimev3_getusers(integer, integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtimev3_getusers(
    IN p_departno integer,
    IN p_index integer,
    IN p_viewcount integer,
    IN p_uid character varying DEFAULT '',
    IN p_uname character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM (
		   SELECT
		   		ROW_NUMBER() OVER(ORDER BY COALESCE(S.SortNo,99999) ASC, P.SortNo ASC,  U.Name ASC) AS RowNum
				, pTotal = COUNT(*) OVER()
				,U.UserNo, U.UserID, U.Name, U.Name_EN
				,D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN
				,P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN
				,U.BirthDate
				, public."WorkingTime_GetCompanyName"(U.UserNo,'') as Company
			FROM  Organization_Users U
			left join Organization_BelongToDepartment  B  ON U.UserNo = B.UserNo  AND U.IsVirtual = FALSE and B.IsDefault = TRUE
			INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
			INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
			LEFT JOIN Organization_SortingEachDepartment S ON S.UserNo = U.UserNo and S.DepartNo = workingtimev3_getusers.p_departno
			WHERE (p_DepartNo = 0 OR B.DepartNo IN (SELECT DepartNo FROM public."Organization_GetDepartments_Reflexive"(p_DepartNo, 0)))
			and u.Enabled = TRUE
			AND (p_Uid = '' OR LOWER(U.UserID) ILIKE '%' || p_Uid || '%')
			AND (p_UName = '' OR LOWER(U.Name) ILIKE '%' || p_UName || '%')
						) X  WHERE X.RowNum BETWEEN ((p_Index - 1) * p_ViewCount) + 1  AND (p_Index * p_ViewCount)
			order by X.RowNum;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
