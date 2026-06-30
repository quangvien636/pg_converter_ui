-- ─── FUNCTION: board_getstatusapprovalpermission ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getstatusapprovalpermission(integer, integer);
CREATE OR REPLACE FUNCTION public.board_getstatusapprovalpermission(
    userno integer DEFAULT 6656,
    boardno integer DEFAULT 1211
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT Count(*)  FROM Board_NoticePermission WHERE UserNo=board_getstatusapprovalpermission.userno AND ItemNo= board_getstatusapprovalpermission.boardno AND AllowValue>0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
