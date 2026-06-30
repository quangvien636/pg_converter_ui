-- ─── FUNCTION: board_updateapprovaldoc ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updateapprovaldoc(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.board_updateapprovaldoc(
    contentno integer,
    status character varying,
    userno integer
) RETURNS void
AS $function$
BEGIN

UPDATE Board_Contents
SET ApplyTo=board_updateapprovaldoc.status,ModUserNo=board_updateapprovaldoc.userno, ModDate=NOW()
Where ContentNo= board_updateapprovaldoc.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
