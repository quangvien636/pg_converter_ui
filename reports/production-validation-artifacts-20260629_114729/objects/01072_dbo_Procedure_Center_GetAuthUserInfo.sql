-- ─── PROCEDURE→FUNCTION: center_getauthuserinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getauthuserinfo(integer);
CREATE OR REPLACE FUNCTION public.center_getauthuserinfo(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF UserNo <> 0 THEN
		
		RETURN QUERY
		SELECT UserNo, UserID, Password, PasswordChangeDate, Enabled
		FROM Organization_Users WHERE UserNo = center_getauthuserinfo.userno
		
	END IF;
	
	ELSIF UserID <> '' THEN
		
		RETURN QUERY
		SELECT UserNo, UserID, Password, PasswordChangeDate, Enabled
		FROM Organization_Users WHERE UserID = UserID
		
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
