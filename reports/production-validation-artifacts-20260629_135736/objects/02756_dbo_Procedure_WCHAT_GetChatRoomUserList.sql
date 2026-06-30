-- ─── PROCEDURE→FUNCTION: wchat_getchatroomuserlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.wchat_getchatroomuserlist(integer);
CREATE OR REPLACE FUNCTION public.wchat_getchatroomuserlist(
    IN chatno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	RETURN QUERY
	SELECT M.ChatNo, M.MemberNo, M.UserNo, M.IsAlarm, M.RegDate FROM WCHATMembers M
	WHERE M.ChatNo = wchat_getchatroomuserlist.chatno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
