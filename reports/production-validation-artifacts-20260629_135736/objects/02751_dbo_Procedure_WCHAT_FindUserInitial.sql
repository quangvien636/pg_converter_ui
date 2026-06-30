-- ─── PROCEDURE→FUNCTION: wchat_finduserinitial ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.wchat_finduserinitial();
CREATE OR REPLACE FUNCTION public.wchat_finduserinitial(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	RETURN QUERY
	SELECT U.Name
	FROM WCHATMembers M
	INNER JOIN Organization_Users U ON U.UserNo = M.UserNo
	WHERE PATINDEX(public."UF_RegularExText"(FindText) + '%' , U.Name) > 0
	--WHERE PATINDEX('%' || public."UF_RegularExText"(FindText) + '%' , U.UserNm1) > 0
	GROUP BY U.Name;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
