-- ─── PROCEDURE→FUNCTION: sns_getgroupuserinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_getgroupuserinfo();
CREATE OR REPLACE FUNCTION public.sns_getgroupuserinfo(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT COUNT(*)
	FROM SnsGroupUsers G
	INNER JOIN Organization_Users U ON U.UserNo = G.UserNo
	WHERE G.GroupNo = GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
