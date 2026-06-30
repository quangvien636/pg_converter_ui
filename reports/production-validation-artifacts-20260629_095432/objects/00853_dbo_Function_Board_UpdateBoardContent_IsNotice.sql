-- ─── FUNCTION: board_updateboardcontent_isnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updateboardcontent_isnotice(bigint, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_isnotice(
    contentno bigint,
    moddate timestamp without time zone,
    isnotice boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ModDate = board_updateboardcontent_isnotice.moddate,
		IsNotice = board_updateboardcontent_isnotice.isnotice
	WHERE ContentNo = board_updateboardcontent_isnotice.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
