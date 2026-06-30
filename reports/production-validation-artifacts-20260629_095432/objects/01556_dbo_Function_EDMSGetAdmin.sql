-- ─── FUNCTION: edmsgetadmin ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgetadmin();
CREATE OR REPLACE FUNCTION public.edmsgetadmin(
) RETURNS TABLE(
    userid text,
    usernm text,
    grpnm text,
    orgnm text
)
AS $function$
BEGIN
	--*/	
	/***************************************************************************
	-- EDMSDOCUMENT INSERT
	***************************************************************************/
	RETURN QUERY
	SELECT	UserID
	,		''	as UserNm
	,		''	as GrpNm
	,		'' as OrgNm		
	FROM EDMSUSERENV 
	WHERE	ADMINFLAG = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
