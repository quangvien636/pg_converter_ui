-- ─── PROCEDURE→FUNCTION: workingtime_getlistimage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getlistimage(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlistimage(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT ImageNo,UserNo,DateUpload = CONVERT(char(10), DateUpload,126) + ' ' || CONVERT(char(5), DateUpload, 108),UrlImage FROM WorkingTime_Images
	WHERE CONVERT(CHAR(10), DateUpload,126) = DateUpload and UserNo = workingtime_getlistimage.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
