-- ─── FUNCTION: board_updateboardcontent_content ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updateboardcontent_content(bigint);
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_content(
    contentno bigint
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_Contents SET
		Content = Content
	WHERE ContentNo = board_updateboardcontent_content.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
