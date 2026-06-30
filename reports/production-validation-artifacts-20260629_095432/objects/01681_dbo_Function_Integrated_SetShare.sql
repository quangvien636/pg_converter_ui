-- ─── FUNCTION: integrated_setshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_setshare(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.integrated_setshare(
    integratedno integer,
    departno integer,
    ischild character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    departname character varying;
BEGIN

	IF Mode = 0
	BEGIN

		SET DepartName = public."COMNGetDepartName"(DepartNo);
		INSERT INTO Integrated_Sharers(IntegratedNo,DepartNo,DepartName,IsChild)
		VALUES(IntegratedNo,DepartNo,DepartName,IsChild)
	END
	ELSE
	BEGIN;
		DELETE FROM Integrated_Sharers WHERE IntegratedNo = integrated_setshare.integratedno
	END
	
	RETURN QUERY
	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
