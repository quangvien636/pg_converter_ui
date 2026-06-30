-- ─── FUNCTION: center_googleotp_delete ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_googleotp_delete();
CREATE OR REPLACE FUNCTION public.center_googleotp_delete(
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_GoogleOTPInfo WHERE UserID = UserID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
