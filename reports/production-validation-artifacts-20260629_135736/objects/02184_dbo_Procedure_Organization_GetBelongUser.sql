-- ─── PROCEDURE→FUNCTION: organization_getbelonguser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getbelonguser(bigint);
CREATE OR REPLACE FUNCTION public.organization_getbelonguser(
    IN belongno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

			
		RETURN QUERY
		SELECT B.BelongNo,
			D.DepartNo, P.PositionNo, COALESCE(DT.DutyNo, 0) AS DutyNo, B.IsDefault,
			D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
			P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo,
			COALESCE(DT.Name, '') AS DutyName, COALESCE(DT.Name_EN, '') AS DutyName_EN, COALESCE(DT.SortNo, 9999) AS DutySortNo
			,D.Name_CH AS DepartName_CH,D.Name_JP AS DepartName_JP,D.Name_VN AS DepartName_VN
			,P.Name_CH AS PositionName_CH,P.Name_JP AS PositionName_JP,P.Name_VN AS PositionName_VN
			,COALESCE(DT.Name_CH, '') AS DutyName_CH,COALESCE(DT.Name_JP, '') AS DutyName_JP,COALESCE(DT.Name_VN, '') AS DutyName_VN
			,D.SenderName
		FROM Organization_BelongToDepartment B
		INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
		INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
		LEFT JOIN Organization_Duties DT ON DT.DutyNo = B.DutyNo
		WHERE B.BelongNo = organization_getbelonguser.belongno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
