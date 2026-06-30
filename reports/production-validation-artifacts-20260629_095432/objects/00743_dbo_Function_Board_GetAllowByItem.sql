-- ─── FUNCTION: board_getallowbyitem ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getallowbyitem(integer, integer);
CREATE OR REPLACE FUNCTION public.board_getallowbyitem(
    itemno integer,
    itemtype integer
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
		WHERE ItemNo = board_getallowbyitem.itemno AND ItemType=board_getallowbyitem.itemtype;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
