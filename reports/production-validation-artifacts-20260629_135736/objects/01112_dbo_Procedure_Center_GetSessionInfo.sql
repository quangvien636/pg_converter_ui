-- ─── PROCEDURE→FUNCTION: center_getsessioninfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getsessioninfo(integer, character varying);
CREATE OR REPLACE FUNCTION public.center_getsessioninfo(
    IN userno integer,
    IN userid character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF UserNo != 0 THEN
	
		RETURN QUERY
		SELECT UserNo, UserID, SessionID
		FROM Center_Sessions WHERE UserNo = center_getsessioninfo.userno
	
	END IF;
	
	ELSIF UserID != '' THEN
	
		RETURN QUERY
		SELECT UserNo, UserID, SessionID
		FROM Center_Sessions WHERE UserID = center_getsessioninfo.userid
	
	END IF;
	
	ELSIF SessionID != '' THEN
	
		RETURN QUERY
		SELECT UserNo, UserID, SessionID
		FROM Center_Sessions WHERE SessionID = SessionID
	
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
