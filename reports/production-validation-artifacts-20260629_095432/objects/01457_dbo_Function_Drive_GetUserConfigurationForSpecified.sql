-- ─── FUNCTION: drive_getuserconfigurationforspecified ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getuserconfigurationforspecified();
CREATE OR REPLACE FUNCTION public.drive_getuserconfigurationforspecified(
) RETURNS TABLE(
    userno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    usernos table (
		userno int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SET oPos = 1
	SET nPos = 1

	WHILE (nPos > 0) BEGIN
	
		SET nPos = STRPOS(ListOfUsers, oPos, ';')

		IF (nPos = 0)
			SET TmpVar = RIGHT(ListOfUsers, LEN(ListOfUsers) - oPos + 1)
		ELSE
			SET TmpVar = SUBSTRING(ListOfUsers, oPos, nPos - oPos)

		IF (LEN(TmpVar) > 0);
			INSERT INTO UserNos VALUES (TmpVar)
			
		SET oPos = nPos + 1

	END

	RETURN QUERY
	SELECT UserNo, MaxLengthForMyDrive
	FROM Drive_UserConfigurations
	WHERE UserNo IN (SELECT UserNo FROM UserNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
