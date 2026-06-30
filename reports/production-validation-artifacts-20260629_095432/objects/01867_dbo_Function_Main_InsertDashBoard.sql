-- ─── FUNCTION: main_insertdashboard ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_insertdashboard(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.main_insertdashboard(
    moduserno integer,
    moddate timestamp without time zone
) RETURNS TABLE(
    boardno text
)
AS $function$
DECLARE
    boardno integer;
BEGIN


	INSERT INTO Main_DashBoards (ModUserNo, ModDate, Name)
	VALUES (ModUserNo, ModDate, Name)
	

	SET BoardNo = lastval()
	
	RETURN QUERY
	SELECT BoardNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
