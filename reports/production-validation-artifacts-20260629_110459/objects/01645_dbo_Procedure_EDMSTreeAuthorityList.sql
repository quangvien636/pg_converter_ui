-- ─── PROCEDURE→FUNCTION: edmstreeauthoritylist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmstreeauthoritylist(character varying);
CREATE OR REPLACE FUNCTION public.edmstreeauthoritylist(
    IN folderid character varying
) RETURNS SETOF record
AS $function$
DECLARE
    folderid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	/*	test

FolderID := (1);
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
