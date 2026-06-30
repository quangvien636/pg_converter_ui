-- ─── PROCEDURE→FUNCTION: workingtime_getdepartmentsbyuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getdepartmentsbyuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getdepartmentsbyuser(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		RETURN QUERY
		SELECT O.DepartNo, ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled
				,Name_CH,Name_JP,Name_VN
		FROM Organization_Departments O
		INNER JOIN Organization_BelongToDepartment F
		ON O.DepartNo = F.DepartNo
		WHERE Enabled = TRUE And F.UserNo = workingtime_getdepartmentsbyuser.userno
		ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
