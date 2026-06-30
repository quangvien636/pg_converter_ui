-- ─── FUNCTION: board_insertdepartallowaccess ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_insertdepartallowaccess(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_insertdepartallowaccess(
    departno integer DEFAULT 6355,
    allowvalue integer DEFAULT 0,
    itemno integer DEFAULT 1160,
    itemtype integer DEFAULT 2,
    userno integer DEFAULT 70
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	INSERT INTO Board_DepartAllowAccess (DepartNo,AllowValue , ItemNo,ItemType,RegUserNo,RegDate,ModUserNo,ModDate)
	VALUES (DepartNo, AllowValue, ItemNo,ItemType,UserNo,NOW(),UserNo,NOW())
	RETURN QUERY
	SELECT lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
