-- ─── PROCEDURE→FUNCTION: drive_updateuserconfiguration ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_updateuserconfiguration(integer, bigint);
CREATE OR REPLACE FUNCTION public.drive_updateuserconfiguration(
    IN userno integer,
    IN maxlengthformydrive bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (SELECT COUNT(*) FROM Drive_UserConfigurations WHERE UserNo = drive_updateuserconfiguration.userno) != 0 THEN

		UPDATE Drive_UserConfigurations SET MaxLengthForMyDrive = drive_updateuserconfiguration.maxlengthformydrive
		WHERE UserNo = drive_updateuserconfiguration.userno

	END ELSE BEGIN

		EXEC Drive_InsertUserConfiguration UserNo, MaxLengthForMyDrive

	END IF;

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
