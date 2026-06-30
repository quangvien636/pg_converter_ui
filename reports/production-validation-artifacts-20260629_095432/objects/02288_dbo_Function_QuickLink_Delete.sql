-- ─── FUNCTION: quicklink_delete ───────────────────────────────
DROP FUNCTION IF EXISTS public.quicklink_delete(bigint);
CREATE OR REPLACE FUNCTION public.quicklink_delete(
    seq bigint
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	

	SELECT exist = quicklink_delete.seq FROM  public."QuickLink" WHERE Seq = quicklink_delete.seq

	DELETE FROM public."QuickLink" 
		WHERE Seq = quicklink_delete.seq

	RETURN QUERY
	SELECT exist;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
