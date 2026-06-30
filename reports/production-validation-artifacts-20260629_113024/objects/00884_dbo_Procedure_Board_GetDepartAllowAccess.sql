-- ─── PROCEDURE→FUNCTION: board_getdepartallowaccess ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getdepartallowaccess(integer, integer);
CREATE OR REPLACE FUNCTION public.board_getdepartallowaccess(
    IN itemno integer,
    IN itemtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT A.AllowAccessNo,A.DepartNo,A.AllowValue,A.ItemNo,A.ItemType ,
	CASE WHEN LangCode='KO' THEN D.Name ELSE COALESCE(D.Name_EN,D.Name) END AS DepartName,
		CASE WHEN A.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS IsAdmin ,
		CASE WHEN A.AllowValue%2<>0 OR A.AllowValue =2 OR A.AllowValue =6 THEN TRUE ELSE FALSE END AS IsRead ,
		CASE WHEN A.AllowValue%2<>0 OR A.AllowValue =4 OR A.AllowValue =6 THEN TRUE ELSE FALSE END AS IsWrite ,
		FALSE  AS DisableAdmin ,
		CASE WHEN A.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS DisableWrite ,
		CASE WHEN A.AllowValue%2<>0 OR A.AllowValue=4 OR A.AllowValue=6 THEN TRUE ELSE FALSE END AS DisableRead
	FROM Board_DepartAllowAccess A
	INNER JOIN Organization_Departments D ON D.DepartNo=A.DepartNo
	WHERE A.ItemNo=board_getdepartallowaccess.itemno AND A.ItemType=board_getdepartallowaccess.itemtype;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
