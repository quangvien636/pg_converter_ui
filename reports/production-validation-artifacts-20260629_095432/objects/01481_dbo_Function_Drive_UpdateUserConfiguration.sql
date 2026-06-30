-- ─── FUNCTION: drive_updateuserconfiguration ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_updateuserconfiguration(integer, bigint);
CREATE OR REPLACE FUNCTION public.drive_updateuserconfiguration(
    userno integer,
    maxlengthformydrive bigint
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	IF (SELECT COUNT(*) FROM Drive_UserConfigurations WHERE UserNo = drive_updateuserconfiguration.userno) != 0 BEGIN

		UPDATE Drive_UserConfigurations SET MaxLengthForMyDrive = drive_updateuserconfiguration.maxlengthformydrive
		WHERE UserNo = drive_updateuserconfiguration.userno

	END ELSE BEGIN

		EXEC Drive_InsertUserConfiguration UserNo, MaxLengthForMyDrive

	END

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
