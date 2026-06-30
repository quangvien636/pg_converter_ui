-- ─── PROCEDURE→FUNCTION: center_setsessioninfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_setsessioninfo(integer, character varying);
CREATE OR REPLACE FUNCTION public.center_setsessioninfo(
    IN userno integer,
    IN userid character varying
) RETURNS void
AS $function$
BEGIN


	IF (SELECT COUNT(*) FROM Center_Sessions (NOLOCK THEN
		WHERE UserNo = center_setsessioninfo.userno AND UserID = center_setsessioninfo.userid AND SessionID = SessionID) = 0) BEGIN
	
		INSERT INTO Center_Sessions (UserNo, UserID, SessionID)
		VALUES (UserNo, UserID, SessionID)
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
