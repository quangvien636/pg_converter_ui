-- ─── PROCEDURE→FUNCTION: sns_getfreetalkinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_getfreetalkinfo();
CREATE OR REPLACE FUNCTION public.sns_getfreetalkinfo(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT G.GroupNo, G.GroupName, G.GroupType, G.OpenType,
	(SELECT COUNT(*) FROM SnsMessageChk AS M WHERE M.GroupNo = G.GroupNo AND M.IsCheck = FALSE AND M.UserNo=UserNo) AS NoReadCnt
	FROM SnsGroups AS G
	WHERE GroupType=101 AND Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
