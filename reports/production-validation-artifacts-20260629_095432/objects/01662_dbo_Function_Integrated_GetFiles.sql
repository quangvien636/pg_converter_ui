-- ─── FUNCTION: integrated_getfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_getfiles(bigint);
CREATE OR REPLACE FUNCTION public.integrated_getfiles(
    contentno bigint
) RETURNS TABLE(
    fileno text,
    name text,
    size text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT FileNo, Name, Size
	FROM Integrated_Files
	WHERE ContentNo = integrated_getfiles.contentno

END;
-----------------------////////////////////////////////////-----------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
