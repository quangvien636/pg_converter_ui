-- ─── FUNCTION: board_updateboardcontent_enabledforuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updateboardcontent_enabledforuser(bigint, timestamp without time zone, boolean, integer);
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_enabledforuser(
    contentno bigint,
    moddate timestamp without time zone,
    enabled boolean,
    userno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ModDate = board_updateboardcontent_enabledforuser.moddate,
		Enabled = board_updateboardcontent_enabledforuser.enabled
	WHERE ContentNo = board_updateboardcontent_enabledforuser.contentno AND RegUserNo = board_updateboardcontent_enabledforuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
