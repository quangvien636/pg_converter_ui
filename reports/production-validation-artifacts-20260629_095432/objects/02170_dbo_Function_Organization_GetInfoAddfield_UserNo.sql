-- ─── FUNCTION: organization_getinfoaddfield_userno ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getinfoaddfield_userno(integer);
CREATE OR REPLACE FUNCTION public.organization_getinfoaddfield_userno(
    userno integer
) RETURNS TABLE(
    col1 text,
    value text,
    name text
)
AS $function$
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
