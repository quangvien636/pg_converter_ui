-- ─── PROCEDURE→FUNCTION: workingtimev3_getuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtimev3_getuser(integer);
CREATE OR REPLACE FUNCTION public.workingtimev3_getuser(
    IN p_uno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		   RETURN QUERY
		   SELECT
		   		1 AS RowNum
				, pTotal = 1
				,U.UserNo, U.UserID, U.Name, U.Name_EN
				,D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN
				,P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN
				,U.BirthDate
				, public."WorkingTime_GetCompanyName"(U.UserNo,'') as Company
			FROM (select max(BelongNo) BelongNo,max(PositionNo) PositionNo, max(DepartNo) DepartNo,  UserNo from  Organization_BelongToDepartment group by UserNo) B 
			INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo  AND U.IsVirtual = FALSE
			INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
			INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
			WHERE B.UserNo = workingtimev3_getuser.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
