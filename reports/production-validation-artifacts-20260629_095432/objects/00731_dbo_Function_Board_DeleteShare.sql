-- ─── FUNCTION: board_deleteshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_deleteshare(integer);
CREATE OR REPLACE FUNCTION public.board_deleteshare(
    contentno integer
) RETURNS void
AS $function$
BEGIN

DELETE FROM Board_Sharers WHERE ContentNo = board_deleteshare.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
