-- ─── PROCEDURE→FUNCTION: drive_insertuserconfiguration ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_insertuserconfiguration(integer, bigint);
CREATE OR REPLACE FUNCTION public.drive_insertuserconfiguration(
    IN userno integer,
    IN maxlengthformydrive bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Drive_UserConfigurations (UserNo, MaxLengthForMyDrive)
	VALUES (UserNo, MaxLengthForMyDrive)

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
