-- ─── FUNCTION: board_updateboardcustorm ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updateboardcustorm(integer, integer);
CREATE OR REPLACE FUNCTION public.board_updateboardcustorm(
    boardno integer DEFAULT 49,
    boardtype integer DEFAULT 23
) RETURNS void
AS $function$
BEGIN

		UPDATE Board_Boards SET ViewMode=board_updateboardcustorm.boardtype WHERE BoardNo=board_updateboardcustorm.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
