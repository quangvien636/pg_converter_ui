-- ─── FUNCTION: center_setsessioninfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_setsessioninfo(integer, character varying);
CREATE OR REPLACE FUNCTION public.center_setsessioninfo(
    userno integer,
    userid character varying
) RETURNS void
AS $function$
BEGIN


	IF ((SELECT COUNT(*) FROM Center_Sessions
		WHERE UserNo = center_setsessioninfo.userno AND UserID = center_setsessioninfo.userid AND SessionID = SessionID) = 0) BEGIN
	
		INSERT INTO Center_Sessions (UserNo, UserID, SessionID)
		VALUES (UserNo, UserID, SessionID)
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
