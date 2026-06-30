-- ─── PROCEDURE→FUNCTION: wchat_insertchatmember ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.wchat_insertchatmember(integer);
CREATE OR REPLACE FUNCTION public.wchat_insertchatmember(
    IN chatno integer
) RETURNS SETOF record
AS $function$
DECLARE
    memberno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	

	MemberNo := 0;;
	INSERT INTO WCHATMembers (ChatNo,UserNo,IsAlarm,RegDate)	
	RETURN QUERY
	SELECT ChatNo,U.UserNo,1,NOW()
	FROM Organization_Users U
	WHERE U.UserNo IN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(UserNos,';'))
	AND U.UserNo NOT IN (SELECT UserNo FROM WCHATMembers WHERE ChatNo = wchat_insertchatmember.chatno)
	AND U.Enabled = TRUE
	GROUP BY U.UserNo
	
	IF lastval() > 0 THEN
		MemberNo := lastval();
	END IF;
	
	RETURN QUERY
	SELECT MemberNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
