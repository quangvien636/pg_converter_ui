-- ─── FUNCTION: board_updateboardcontent_enabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updateboardcontent_enabled(bigint, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_enabled(
    contentno bigint,
    moddate timestamp without time zone,
    enabled boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ModDate = board_updateboardcontent_enabled.moddate,
		Enabled = board_updateboardcontent_enabled.enabled
	WHERE ContentNo = board_updateboardcontent_enabled.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
