-- ─── PROCEDURE→FUNCTION: dday_deletecountofappbadge ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.dday_deletecountofappbadge(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletecountofappbadge(
    IN dayno bigint
) RETURNS SETOF record
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



	SearchText := '/' || CONVERT(VARCHAR, DayNo) + '/';
	SearchTextLength := LEN(SearchText);
	)


	)

	INSERT INTO Users
	RETURN QUERY
	SELECT UserNo, BadgeCount, ListOfDays
	FROM DDay_CountOfAppBadge
	WHERE ListOfDays ILIKE '%' || SearchText || '%'


		_UserNo INT, _BadgeCount INT, _ListOfDays text, _ListOfDays_After text

	CurrentIndex := 1;
	TotalRowCount := (SELECT COUNT(*) FROM Users);
	WHILE CurrentIndex <= TotalRowCount LOOP

		SELECT UserNo, BadgeCount INTO _userno, _badgecount FROM Users WHERE RowIndex = CurrentIndex

		Length := LEN(_ListOfDays);
		FindIndex := STRPOS(_ListOfDays, SearchText);
		IF FindIndex = 1 THEN

			_ListOfDays_After := '/' || REPLACE(_ListOfDays, SearchText, '');
		END IF;
	
		ELSIF FindIndex + SearchTextLength - 1 = Length THEN

			_ListOfDays_After := REPLACE(_ListOfDays, SearchText, '') + '/';
		END IF;

		ELSE BEGIN

			_ListOfDays_After := REPLACE(LEFT(_ListOfDays, FindIndex);
				+ SUBSTRING(_ListOfDays, FindIndex, LEN(_ListOfDays) - FindIndex + 1), SearchText, '')

		END LOOP;

		IF _ListOfDays_After = '/' THEN

			_ListOfDays_After := '';
		END IF;

		INSERT INTO Users_After
		VALUES (_UserNo, _BadgeCount - 1, _ListOfDays_After)

		CurrentIndex := CurrentIndex + 1;
	END;

	-------------------------------------------------------------------------------------------------------

	CurrentIndex := 1;
	TotalRowCount := (SELECT COUNT(*) FROM Users_After);
	WHILE CurrentIndex <= TotalRowCount LOOP

		SELECT UserNo, BadgeCount INTO _userno, _badgecount FROM Users_After WHERE RowIndex = CurrentIndex

		UPDATE DDay_CountOfAppBadge SET BadgeCount = _BadgeCount, ListOfDays = _ListOfDays
		WHERE UserNo = _UserNo

		CurrentIndex := CurrentIndex + 1;
	END LOOP;

	RETURN QUERY
	SELECT UserNo, BadgeCount
	FROM DDay_CountOfAppBadge WHERE UserNo IN (SELECT UserNo FROM Users_After);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
