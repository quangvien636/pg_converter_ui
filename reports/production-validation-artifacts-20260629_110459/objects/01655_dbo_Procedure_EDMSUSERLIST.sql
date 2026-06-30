-- ─── PROCEDURE→FUNCTION: edmsuserlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmsuserlist(character varying);
CREATE OR REPLACE FUNCTION public.edmsuserlist(
    IN orgcd character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
RETURN QUERY
select	a.UserId	
,		a.Name	as UserNm
,		''		as GrpNm
,		c.Name as OrgNm		
,		public."EDMSGetAuthorityLevelContents"(d.AuthorityLevel) AS AuthorityLevel
FROM	Organization_Users   A
		left join
  		Organization_BelongToDepartment	b
		on	A.USERNO=b.UserNo
		left JOIN
		Organization_Departments	c
		on	b.DepartNo = c.DepartNo
		left join
		edmsUserEnv d
		on	a.userid = d.userid 
WHERE	c.DepartNo ILIKE ORGCD
and		a.Enabled = '1';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
