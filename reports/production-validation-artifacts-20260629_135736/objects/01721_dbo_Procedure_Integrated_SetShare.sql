-- ─── PROCEDURE→FUNCTION: integrated_setshare ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_setshare(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_setshare(
    IN integratedno integer,
    IN departno integer,
    IN ischild character varying
) RETURNS SETOF record
AS $function$
DECLARE
    departname character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = 0 THEN

		DepartName := public."COMNGetDepartName"(DepartNo);;
		INSERT INTO Integrated_Sharers(IntegratedNo,DepartNo,DepartName,IsChild)
		VALUES(IntegratedNo,DepartNo,DepartName,IsChild)
	END IF;
	ELSE;
		DELETE FROM Integrated_Sharers WHERE IntegratedNo = integrated_setshare.integratedno
	END IF;
	
	RETURN QUERY
	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
