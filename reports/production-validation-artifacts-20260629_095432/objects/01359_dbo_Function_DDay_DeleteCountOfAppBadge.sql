-- ─── FUNCTION: dday_deletecountofappbadge ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deletecountofappbadge(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletecountofappbadge(
    dayno bigint
) RETURNS TABLE(
    userno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    users table (
		rowindex	int identity,
		userno		int,
		badgecount	int,
		listofdays	varchar(max);
    users_after table (
		rowindex	int identity,
		userno		int,
		badgecount	int,
		listofdays	varchar(max);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SET SearchText = '/' || CONVERT(VARCHAR, DayNo) + '/'
	SET SearchTextLength = LEN(SearchText)


	)


	)

	INSERT INTO Users
	RETURN QUERY
	SELECT UserNo, BadgeCount, ListOfDays
	FROM DDay_CountOfAppBadge
	WHERE ListOfDays ILIKE '%' || SearchText || '%'


		_UserNo INT, _BadgeCount INT, _ListOfDays text, _ListOfDays_After text

	SET CurrentIndex = 1
	SET TotalRowCount = (SELECT COUNT(*) FROM Users)

	WHILE (CurrentIndex <= TotalRowCount) BEGIN

		SELECT _UserNo = UserNo, _BadgeCount = BadgeCount, _ListOfDays = ListOfDays
		FROM Users WHERE RowIndex = CurrentIndex

		SET Length = LEN(_ListOfDays)
		SET FindIndex = STRPOS(_ListOfDays, SearchText)

		IF (FindIndex = 1) BEGIN

			SET _ListOfDays_After = '/' || REPLACE(_ListOfDays, SearchText, '')

		END
	
		ELSE IF (FindIndex + SearchTextLength - 1 = Length) BEGIN

			SET _ListOfDays_After = REPLACE(_ListOfDays, SearchText, '') + '/'

		END

		ELSE BEGIN

			SET _ListOfDays_After = REPLACE(LEFT(_ListOfDays, FindIndex)
				+ SUBSTRING(_ListOfDays, FindIndex, LEN(_ListOfDays) - FindIndex + 1), SearchText, '')

		END

		IF (_ListOfDays_After = '/') BEGIN

			SET _ListOfDays_After = ''

		END

		INSERT INTO Users_After
		VALUES (_UserNo, _BadgeCount - 1, _ListOfDays_After)

		SET CurrentIndex = CurrentIndex + 1

	END

	-------------------------------------------------------------------------------------------------------

	SET CurrentIndex = 1
	SET TotalRowCount = (SELECT COUNT(*) FROM Users_After)

	WHILE (CurrentIndex <= TotalRowCount) BEGIN

		SELECT _UserNo = UserNo, _BadgeCount = BadgeCount, _ListOfDays = ListOfDays
		FROM Users_After WHERE RowIndex = CurrentIndex

		UPDATE DDay_CountOfAppBadge SET BadgeCount = _BadgeCount, ListOfDays = _ListOfDays
		WHERE UserNo = _UserNo

		SET CurrentIndex = CurrentIndex + 1

	END

	RETURN QUERY
	SELECT UserNo, BadgeCount
	FROM DDay_CountOfAppBadge WHERE UserNo IN (SELECT UserNo FROM Users_After);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
