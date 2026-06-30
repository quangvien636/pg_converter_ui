-- ─── FUNCTION: main_getdashboards ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_getdashboards(integer);
CREATE OR REPLACE FUNCTION public.main_getdashboards(
    userno integer
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
	WHERE ModUserNo = main_getdashboards.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
