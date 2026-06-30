-- ─── FUNCTION: board_insertusersetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_insertusersetting(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_insertusersetting(
    userno integer,
    modeview integer,
    pagesize integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

		
--	IF ((SELECT COUNT(*) FROM Board_UserSetting WHERE UserNo = UserNo) >0 )
	IF ((SELECT COUNT(*) FROM Board_UserSetting) >0 )
	BEGIN;
		UPDATE Board_UserSetting 
		SET ModeView=board_insertusersetting.modeview , PageSize=board_insertusersetting.pagesize,UserNo = board_insertusersetting.userno
		RETURN QUERY
		SELECT 1
	END
	ELSE
	BEGIN;
		INSERT INTO Board_UserSetting (UserNo, ModeView, PageSize)
		VALUES (UserNo, ModeView, PageSize)
		RETURN QUERY
		SELECT 0
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
