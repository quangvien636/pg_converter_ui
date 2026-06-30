-- ─── FUNCTION: edmsuserlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsuserlist(character varying);
CREATE OR REPLACE FUNCTION public.edmsuserlist(
    orgcd character varying
) RETURNS TABLE(
    userid text,
    usernm text,
    grpnm text,
    orgnm text,
    authoritylevel text
)
AS $function$
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
