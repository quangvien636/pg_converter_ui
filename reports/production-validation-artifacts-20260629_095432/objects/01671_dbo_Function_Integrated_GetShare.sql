-- ─── FUNCTION: integrated_getshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_getshare(integer);
CREATE OR REPLACE FUNCTION public.integrated_getshare(
    integratedno integer
) RETURNS TABLE(
    departno text,
    departname text,
    ischild text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT DepartNo,DepartName,IsChild FROM Integrated_Sharers WHERE IntegratedNo = integrated_getshare.integratedno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
