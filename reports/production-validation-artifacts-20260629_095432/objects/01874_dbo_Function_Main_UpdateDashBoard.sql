-- ─── FUNCTION: main_updatedashboard ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_updatedashboard(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.main_updatedashboard(
    boardno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Main_DashBoards SET
		ModUserNo = main_updatedashboard.moduserno,
		ModDate = main_updatedashboard.moddate,
		Name = Name
	WHERE BoardNo = main_updatedashboard.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
