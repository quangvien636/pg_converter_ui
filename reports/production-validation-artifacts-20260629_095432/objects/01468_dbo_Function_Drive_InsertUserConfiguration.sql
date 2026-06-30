-- ─── FUNCTION: drive_insertuserconfiguration ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_insertuserconfiguration(integer, bigint);
CREATE OR REPLACE FUNCTION public.drive_insertuserconfiguration(
    userno integer,
    maxlengthformydrive bigint
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	INSERT INTO Drive_UserConfigurations (UserNo, MaxLengthForMyDrive)
	VALUES (UserNo, MaxLengthForMyDrive)

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
