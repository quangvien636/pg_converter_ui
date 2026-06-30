-- ─── FUNCTION: drive_getuserconfiguration ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getuserconfiguration(integer);
CREATE OR REPLACE FUNCTION public.drive_getuserconfiguration(
    userno integer
) RETURNS TABLE(
    userno text,
    maxlengthformydrive text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UserNo, MaxLengthForMyDrive
	FROM Drive_UserConfigurations
	WHERE UserNo = drive_getuserconfiguration.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
