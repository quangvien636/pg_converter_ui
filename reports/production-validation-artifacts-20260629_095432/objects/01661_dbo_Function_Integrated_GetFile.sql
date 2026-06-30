-- ─── FUNCTION: integrated_getfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_getfile(bigint);
CREATE OR REPLACE FUNCTION public.integrated_getfile(
    fileno bigint
) RETURNS TABLE(
    contentno text,
    name text,
    size text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ContentNo, Name, Size
	FROM Integrated_Files
	WHERE FileNo = integrated_getfile.fileno

END;

------------------------//////////////////
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
