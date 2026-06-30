-- ─── PROCEDURE→FUNCTION: center_getquickfunctions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getquickfunctions(integer);
CREATE OR REPLACE FUNCTION public.center_getquickfunctions(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT FunctionNo, UserNo, ApplicationNo, FunctionId, IconUrl, Name, Description, Url, IsPopup, PopupWidth, PopupHeight
	FROM Center_QuickFunctions
	WHERE UserNo = center_getquickfunctions.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
