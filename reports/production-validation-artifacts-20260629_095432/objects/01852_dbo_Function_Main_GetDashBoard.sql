-- ─── FUNCTION: main_getdashboard ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_getdashboard(integer);
CREATE OR REPLACE FUNCTION public.main_getdashboard(
    boardno integer
) RETURNS TABLE(
    boardno text,
    moduserno text,
    moddate text,
    name text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT BoardNo, ModUserNo, ModDate, Name
	FROM Main_DashBoards
	WHERE BoardNo = main_getdashboard.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
