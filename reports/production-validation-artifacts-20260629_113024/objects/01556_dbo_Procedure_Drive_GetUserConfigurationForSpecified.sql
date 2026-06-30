-- ─── PROCEDURE→FUNCTION: drive_getuserconfigurationforspecified ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.drive_getuserconfigurationforspecified();
CREATE OR REPLACE FUNCTION public.drive_getuserconfigurationforspecified(
) RETURNS SETOF record
AS $function$
DECLARE
    usernos table (
		userno int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	oPos := 1;
	nPos := 1;
	WHILE nPos > 0 LOOP
	
		nPos := STRPOS(ListOfUsers, oPos, ';');
		IF nPos = 0 THEN
			TmpVar := RIGHT(ListOfUsers, LEN(ListOfUsers) - oPos + 1);
		ELSE
			TmpVar := SUBSTRING(ListOfUsers, oPos, nPos - oPos);
		IF LEN(TmpVar) > 0 THEN;
			INSERT INTO UserNos VALUES (TmpVar)
			
		oPos := nPos + 1;
	END LOOP;

	RETURN QUERY
	SELECT UserNo, MaxLengthForMyDrive
	FROM Drive_UserConfigurations
	WHERE UserNo IN (SELECT UserNo FROM UserNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
