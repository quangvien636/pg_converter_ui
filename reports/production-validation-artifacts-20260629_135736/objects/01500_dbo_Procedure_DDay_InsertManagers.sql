-- ─── PROCEDURE→FUNCTION: dday_insertmanagers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.dday_insertmanagers(bigint, character varying, boolean);
CREATE OR REPLACE FUNCTION public.dday_insertmanagers(
    IN dayno bigint,
    IN usernos character varying,
    IN isnotification boolean
) RETURNS SETOF record
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



	Original_UserNos := dday_insertmanagers.usernos;
    Index := 1;
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

	END;

	DELETE FROM DDay_Managers WHERE DayNo = dday_insertmanagers.dayno

	INSERT INTO DDay_Managers
	RETURN QUERY
	SELECT DayNo, UserNo
	FROM TableOfUsers

	IF IsNotification = TRUE THEN

		EXEC DDay_InsertCountOfAppBadge DayNo, Original_UserNos, ''

	END IF;

	ELSE BEGIN

		RETURN QUERY
		SELECT 1

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
