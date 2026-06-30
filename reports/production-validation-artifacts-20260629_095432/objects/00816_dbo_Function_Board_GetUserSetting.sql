-- ─── FUNCTION: board_getusersetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getusersetting(integer);
CREATE OR REPLACE FUNCTION public.board_getusersetting(
    userno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ Board_UserSetting.*
	FROM Board_UserSetting;
--	WHERE UserNo = UserNo
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
