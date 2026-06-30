-- ─── FUNCTION: edmstreeauthoritylist ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmstreeauthoritylist(character varying);
CREATE OR REPLACE FUNCTION public.edmstreeauthoritylist(
    folderid character varying
) RETURNS TABLE(
    departid text,
    departname text,
    authorityflag text
)
AS $function$
DECLARE
    folderid integer;
BEGIN
	/*	test

select	FolderID		=	1
	--*/
	RETURN QUERY
	SELECT	E.DEPARTID
	,(case when LangIndex = 1  then D.Name
				when LangIndex=2 then D.Name_EN
				when LangIndex=3 then D.Name_EN
				when LangIndex=4 then D.Name_EN
			end)  AS DEPARTNAME
	,		E.Authorityflag
	FROM	EDMSTreeAuthority E inner join Organization_Departments D ON E.DepartID=D.DepartNo
	WHERE	E.FOLDERID = edmstreeauthoritylist.folderid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
