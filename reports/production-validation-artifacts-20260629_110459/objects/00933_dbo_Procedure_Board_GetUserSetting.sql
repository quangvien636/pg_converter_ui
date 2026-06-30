-- ─── PROCEDURE→FUNCTION: board_getusersetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_getusersetting(integer);
CREATE OR REPLACE FUNCTION public.board_getusersetting(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ Board_UserSetting.*
	FROM Board_UserSetting;
--	WHERE UserNo = UserNo
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
