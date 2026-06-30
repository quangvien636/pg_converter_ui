-- ─── FUNCTION: board_updateboardcontent_titleeffect ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updateboardcontent_titleeffect(bigint, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_titleeffect(
    contentno bigint,
    moddate timestamp without time zone,
    titleeffect integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ModDate = board_updateboardcontent_titleeffect.moddate,
		TitleEffect = board_updateboardcontent_titleeffect.titleeffect
	WHERE ContentNo = board_updateboardcontent_titleeffect.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
