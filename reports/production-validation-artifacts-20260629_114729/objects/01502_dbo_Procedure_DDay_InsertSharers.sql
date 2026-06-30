-- ─── PROCEDURE→FUNCTION: dday_insertsharers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.dday_insertsharers(integer, bigint, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.dday_insertsharers(
    IN userno integer,
    IN dayno bigint,
    IN usernos character varying,
    IN departnos character varying,
    IN isnotification boolean
) RETURNS SETOF record
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



	Original_UserNos := dday_insertsharers.usernos;
	Original_DepartNos := dday_insertsharers.departnos;
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

			INSERT INTO TableOfUsers VALUES (Slice)
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

			INSERT INTO TableOfDepartments VALUES (Slice)
			DepartNos := RIGHT(DepartNos , LEN(DepartNos) - Index);
			IF (LEN(DepartNos) = 0) BREAK THEN

		END IF;

	END;

	-------------------------------------------------------------------------------

	INSERT INTO DDay_Sharers
	RETURN QUERY
	SELECT DayNo, 0, UserNo
	FROM TableOfUsers

	INSERT INTO DDay_Sharers
	RETURN QUERY
	SELECT DayNo, DepartNo, 0
	FROM TableOfDepartments

	IF IsNotification = TRUE THEN

		PERFORM dday_insertcountofappbadge(UserNo, DayNo, Original_UserNos, Original_DepartNos

	END IF;

	ELSE BEGIN

		SELECT 1

	END);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
