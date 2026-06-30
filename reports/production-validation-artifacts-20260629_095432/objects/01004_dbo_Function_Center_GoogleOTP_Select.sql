-- ─── FUNCTION: center_googleotp_select ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_googleotp_select();
CREATE OR REPLACE FUNCTION public.center_googleotp_select(
) RETURNS TABLE(
    userid character varying(100),
    otpsetupkey character varying(50),
    qrcodesetupimageurl text,
    manualentrykey character varying(100),
    regdate timestamp without time zone
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT *
	FROM Center_GoogleOTPInfo WHERE UserID = UserID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
