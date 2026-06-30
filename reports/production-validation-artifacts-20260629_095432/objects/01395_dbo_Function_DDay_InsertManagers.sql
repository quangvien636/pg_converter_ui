-- ─── FUNCTION: dday_insertmanagers ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_insertmanagers(bigint, character varying, boolean);
CREATE OR REPLACE FUNCTION public.dday_insertmanagers(
    dayno bigint,
    usernos character varying,
    isnotification boolean
) RETURNS TABLE(
    dayno text,
    userno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    original_usernos character varying;
    tableofusers table (
		userno	int
	);
    index integer;
    slice character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SET Original_UserNos = dday_insertmanagers.usernos




    SET Index = 1

    WHILE Index != 0 BEGIN
	
		SET Index = STRPOS(', UserNos, ')

        IF (Index != 0) BEGIN
			SELECT Slice = LEFT(UserNos, Index - 1)
		END	
        
		ELSE BEGIN
        
			SELECT Slice = dday_insertmanagers.usernos

		END

		INSERT INTO TableOfUsers VALUES (Slice)
		SET UserNos = RIGHT(UserNos , LEN(UserNos) - Index)

		IF (LEN(UserNos) = 0) BREAK

	END   

	DELETE FROM DDay_Managers WHERE DayNo = dday_insertmanagers.dayno

	INSERT INTO DDay_Managers
	RETURN QUERY
	SELECT DayNo, UserNo
	FROM TableOfUsers

	IF (IsNotification = TRUE) BEGIN

		EXEC DDay_InsertCountOfAppBadge DayNo, Original_UserNos, ''

	END

	ELSE BEGIN

		RETURN QUERY
		SELECT 1

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
