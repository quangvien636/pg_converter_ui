-- ─── FUNCTION: dday_insertcountofappbadge ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_insertcountofappbadge(integer, bigint, character varying);
CREATE OR REPLACE FUNCTION public.dday_insertcountofappbadge(
    userno integer,
    dayno bigint,
    usernos character varying
) RETURNS TABLE(
    userno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    listofusers table (
		userno	int
	);
    index integer;
    slice character varying;
    listofusers_after table (
		rowindex	int identity,
		userno		int
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	SET Index = 1

	IF (LEN(UserNos) != 0) BEGIN

		WHILE Index != 0 BEGIN

			SET Index = STRPOS(', UserNos, ')

			IF (Index != 0) BEGIN

				SELECT Slice = LEFT(UserNos, Index - 1)

			END	
    
			ELSE BEGIN
    
				SELECT Slice = dday_insertcountofappbadge.usernos

			END

			INSERT INTO ListOfUsers VALUES (Slice)
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
    
				SELECT Slice = DepartNos

			END

			INSERT INTO ListOfUsers
			RETURN QUERY
			SELECT UserNo FROM Organization_BelongToDepartment
			WHERE DepartNo IN (SELECT * FROM public."Organization_GetDepartments_Reflexive"(Slice, 0))

			SET DepartNos = RIGHT(DepartNos , LEN(DepartNos) - Index)

			IF (LEN(DepartNos) = 0) BREAK

		END

	END




	INSERT INTO ListOfUsers_After
	RETURN QUERY
	SELECT DISTINCT UserNo
	FROM ListOfUsers WHERE UserNo != 0 AND UserNo != dday_insertcountofappbadge.userno

	SET CurrentIndex = 1
	SET TotalRowCount = (SELECT COUNT(*) FROM ListOfUsers_After)

	WHILE (CurrentIndex <= TotalRowCount) BEGIN

		SET _UserNo = (SELECT UserNo FROM ListOfUsers_After WHERE RowIndex = CurrentIndex)
		SET _ListOfDays = (SELECT ListOfDays FROM DDay_CountOfAppBadge WHERE UserNo = _UserNo)
		SET _ListOfDaysLength = LEN(_ListOfDays)

		IF (_ListOfDaysLength IS NULL) BEGIN

			INSERT INTO DDay_CountOfAppBadge (UserNo, BadgeCount, ListOfDays) VALUES (_UserNo, 1, '/' || CONVERT(VARCHAR, DayNo) + '/')

		END
		
		ELSE IF (_ListOfDaysLength = 0) BEGIN

			UPDATE DDay_CountOfAppBadge SET BadgeCount = 1, ListOfDays = '/' || CONVERT(VARCHAR, DayNo) + '/'
			WHERE UserNo = _UserNo

		END

		ELSE BEGIN

			IF (STRPOS(DayNo, '/' || CONVERT(VARCHAR) + '/', _ListOfDays) = 0) BEGIN

				UPDATE DDay_CountOfAppBadge SET BadgeCount = BadgeCount + 1, ListOfDays = ListOfDays + CONVERT(VARCHAR, DayNo) + '/'
				WHERE UserNo = _UserNo

			END

		END

		SET CurrentIndex = CurrentIndex + 1

	END

	RETURN QUERY
	SELECT UserNo, BadgeCount
	FROM DDay_CountOfAppBadge WHERE UserNo IN (SELECT UserNo FROM ListOfUsers_After);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
