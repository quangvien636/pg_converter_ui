-- ─── PROCEDURE→FUNCTION: dday_insertcountofappbadge ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.dday_insertcountofappbadge(integer, bigint, character varying);
CREATE OR REPLACE FUNCTION public.dday_insertcountofappbadge(
    IN userno integer,
    IN dayno bigint,
    IN usernos character varying
) RETURNS SETOF record
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





	Index := 1;
	IF LEN(UserNos) != 0 THEN

		WHILE Index != 0 LOOP

			Index := STRPOS(', UserNos, ');
			IF Index != 0 THEN

				Slice := (LEFT(UserNos, Index - 1));
			END IF;
    
			ELSE BEGIN
    
				Slice := (UserNos);
			END LOOP;

			INSERT INTO ListOfUsers VALUES (Slice)
			UserNos := RIGHT(UserNos , LEN(UserNos) - Index);
			IF (LEN(UserNos) = 0) BREAK THEN

		END IF;

	END;

	-------------------------------------------------------------------------------

	Index := 1;
	IF LEN(DepartNos) != 0 THEN

		WHILE Index != 0 LOOP

			Index := STRPOS(', DepartNos, ');
			IF Index != 0 THEN

				Slice := (LEFT(DepartNos, Index - 1));
			END IF;
    
			ELSE BEGIN
    
				Slice := (DepartNos);
			END LOOP;

			INSERT INTO ListOfUsers
			RETURN QUERY
			SELECT UserNo FROM Organization_BelongToDepartment
			WHERE DepartNo IN (SELECT * FROM public."Organization_GetDepartments_Reflexive"(Slice, 0))

			DepartNos := RIGHT(DepartNos , LEN(DepartNos) - Index);
			IF (LEN(DepartNos) = 0) BREAK THEN

		END IF;

	END;




	INSERT INTO ListOfUsers_After
	RETURN QUERY
	SELECT DISTINCT UserNo
	FROM ListOfUsers WHERE UserNo != 0 AND UserNo != dday_insertcountofappbadge.userno

	CurrentIndex := 1;
	TotalRowCount := (SELECT COUNT(*) FROM ListOfUsers_After);
	WHILE CurrentIndex <= TotalRowCount LOOP

		_UserNo := (SELECT UserNo FROM ListOfUsers_After WHERE RowIndex = CurrentIndex);
		_ListOfDays := (SELECT ListOfDays FROM DDay_CountOfAppBadge WHERE UserNo = _UserNo);
		_ListOfDaysLength := LEN(_ListOfDays);
		IF _ListOfDaysLength IS NULL THEN

			INSERT INTO DDay_CountOfAppBadge (UserNo, BadgeCount, ListOfDays) VALUES (_UserNo, 1, '/' || CONVERT(VARCHAR, DayNo) + '/')

		END IF;
		
		ELSIF _ListOfDaysLength = 0 THEN

			UPDATE DDay_CountOfAppBadge SET BadgeCount = 1, ListOfDays = '/' || CONVERT(VARCHAR, DayNo) + '/'
			WHERE UserNo = _UserNo

		END IF;

		ELSE BEGIN

			IF STRPOS(DayNo, '/' || CONVERT(VARCHAR) + '/', _ListOfDays) = 0 THEN

				UPDATE DDay_CountOfAppBadge SET BadgeCount = BadgeCount + 1, ListOfDays = ListOfDays + CONVERT(VARCHAR, DayNo) + '/'
				WHERE UserNo = _UserNo

			END IF;

		END LOOP;

		CurrentIndex := CurrentIndex + 1;
	END;

	RETURN QUERY
	SELECT UserNo, BadgeCount
	FROM DDay_CountOfAppBadge WHERE UserNo IN (SELECT UserNo FROM ListOfUsers_After);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
