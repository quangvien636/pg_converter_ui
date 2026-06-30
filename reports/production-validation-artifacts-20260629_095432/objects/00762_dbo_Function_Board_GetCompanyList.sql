-- ─── FUNCTION: board_getcompanylist ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getcompanylist();
CREATE OR REPLACE FUNCTION public.board_getcompanylist(
) RETURNS TABLE(
    departno text,
    name text
)
AS $function$
BEGIN

RETURN QUERY
SELECT DepartNo,Name FROM 
Organization_Departments  Where ParentNo=0 AND Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
