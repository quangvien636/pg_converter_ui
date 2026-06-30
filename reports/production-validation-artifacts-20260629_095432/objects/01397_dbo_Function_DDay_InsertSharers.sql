-- ─── FUNCTION: dday_insertsharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_insertsharers(integer, bigint, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.dday_insertsharers(
    userno integer,
    dayno bigint,
    usernos character varying,
    departnos character varying,
    isnotification boolean
) RETURNS TABLE(
    dayno text,
    departno text,
    0 text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tableofusers table (
		userno	int
	);
    index integer;
    slice character varying;
    tableofdepartments table (
		departno	int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SET Original_UserNos = dday_insertsharers.usernos
	SET Original_DepartNos = dday_insertsharers.departnos




    SET Index = 1

	IF (LEN(UserNos) != 0) BEGIN

		WHILE Index != 0 BEGIN
	
			SET Index = STRPOS(', UserNos, ')

			IF (Index != 0) BEGIN

				SELECT Slice = LEFT(UserNos, Index - 1)

			END	
        
			ELSE BEGIN
        
				SELECT Slice = dday_insertsharers.usernos

			END

			INSERT INTO TableOfUsers VALUES (Slice)
			SET UserNos = RIGHT(UserNos , LEN(UserNos) - Index)

			IF (LEN(UserNos) = 0) BREAK

		END

	END

	-------------------------------------------------------------------------------


    SET Index = 1

	IF (LEN(DepartNos) != 0) BEGIN

		WHILE Index != 0 BEGIN
	
			SET Index = STRPOS(', DepartNos, ')

			IF (Index != 0) BEGIN

				SELECT Slice = LEFT(DepartNos, Index - 1)

			END	
        
			ELSE BEGIN
        
				SELECT Slice = dday_insertsharers.departnos

			END

			INSERT INTO TableOfDepartments VALUES (Slice)
			SET DepartNos = RIGHT(DepartNos , LEN(DepartNos) - Index)

			IF (LEN(DepartNos) = 0) BREAK

		END

	END

	-------------------------------------------------------------------------------

	INSERT INTO DDay_Sharers
	RETURN QUERY
	SELECT DayNo, 0, UserNo
	FROM TableOfUsers

	INSERT INTO DDay_Sharers
	RETURN QUERY
	SELECT DayNo, DepartNo, 0
	FROM TableOfDepartments

	IF (IsNotification = TRUE) BEGIN

		EXEC DDay_InsertCountOfAppBadge UserNo, DayNo, Original_UserNos, Original_DepartNos

	END

	ELSE BEGIN

		RETURN QUERY
		SELECT 1

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
