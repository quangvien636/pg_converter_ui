-- ─── PROCEDURE→FUNCTION: organization_getinfoaddfield_userno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getinfoaddfield_userno(integer);
CREATE OR REPLACE FUNCTION public.organization_getinfoaddfield_userno(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	RETURN QUERY
	select a.*,COALESCE(b.Value,'') as Value from Organization_Users_InfoAddfield a
	left join Organization_Users_Addfields b 
	on a.Code = b.Key and b.UserNo = organization_getinfoaddfield_userno.userno
	*/


	RETURN QUERY
	select a.*,
	COALESCE(b.Value,'') as Value
	,case a.type WHEN 2 THEN COALESCE((select s.Name from Organization_Users_InfoAddfield_Sub s where Code = b.Value),'') ELSE COALESCE(b.Value,'') END ValueName
	from Organization_Users_InfoAddfield a
	left join Organization_Users_Addfields b 
	on a.Code = b.Key and b.UserNo = organization_getinfoaddfield_userno.userno
	order by a.SortNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
