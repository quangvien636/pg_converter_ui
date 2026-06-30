-- ─── FUNCTION: personal_getposition ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_getposition();
CREATE OR REPLACE FUNCTION public.personal_getposition(
) RETURNS TABLE(
    positionno text,
    name text,
    sortno text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT PositionNo, Name, SortNo FROM Positions
	WHERE Enabled = TRUE
	ORDER BY SortNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
