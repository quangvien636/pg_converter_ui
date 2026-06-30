-- ─── PROCEDURE→FUNCTION: sns_getuserdepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_getuserdepartment();
CREATE OR REPLACE FUNCTION public.sns_getuserdepartment(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT B.UserNo, P.Name AS PosName, D.Name AS DepName FROM Organization_BelongToDepartment B
	INNER JOIN Organization_Departments D ON B.DepartNo=D.DepartNo
	INNER JOIN Organization_Positions P ON B.PositionNo=P.PositionNo
	WHERE UserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
