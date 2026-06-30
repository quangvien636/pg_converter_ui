-- ─── FUNCTION: board_updatenoticepermission ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updatenoticepermission(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_updatenoticepermission(
    departno integer DEFAULT 49,
    positionno integer DEFAULT 23,
    userno integer DEFAULT 6656,
    allowvalue integer DEFAULT 2,
    itemno integer DEFAULT 137
) RETURNS TABLE(
    itemno text
)
AS $function$
BEGIN

	DELETE FROM Board_NoticePermission
	WHERE UserNo = board_updatenoticepermission.userno AND ItemNo=board_updatenoticepermission.itemno 
	IF(AllowValue >0)
	BEGIN;
		INSERT INTO public."Board_NoticePermission"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ModDate,RegDate)
		VALUES(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,NOW(),NOW());
	END
	RETURN QUERY
	SELECT ItemNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
