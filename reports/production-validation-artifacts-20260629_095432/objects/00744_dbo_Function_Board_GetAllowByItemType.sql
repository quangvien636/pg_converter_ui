-- ─── FUNCTION: board_getallowbyitemtype ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getallowbyitemtype(integer);
CREATE OR REPLACE FUNCTION public.board_getallowbyitemtype(
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
		WHERE ItemType=board_getallowbyitemtype.itemtype;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
