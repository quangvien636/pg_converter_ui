-- ─── FUNCTION: board_getallowbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getallowbyuser(integer);
CREATE OR REPLACE FUNCTION public.board_getallowbyuser(
    userno integer
) RETURNS TABLE(
    allowaccessno serial,
    departno integer,
    positionno integer,
    userno integer,
    allowvalue integer,
    itemno integer,
    itemtype integer,
    moddate timestamp without time zone,
    regdate timestamp without time zone
)
AS $function$
BEGIN


	
		RETURN QUERY
		SELECT *
		FROM Board_AllowAccess
		WHERE UserNo = board_getallowbyuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
