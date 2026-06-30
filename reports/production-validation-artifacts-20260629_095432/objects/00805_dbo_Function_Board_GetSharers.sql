-- ─── FUNCTION: board_getsharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getsharers(integer);
CREATE OR REPLACE FUNCTION public.board_getsharers(
    contentno integer DEFAULT 4741
) RETURNS TABLE(
    departno text,
    departname text,
    ischild text,
    userno text,
    username text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT BS.DepartNo,BS.DepartName,BS.IsChild,BS.UserNo ,U.UserID AS UserName
	FROM Board_Sharers BS
	LEFT JOIN ORGANIZATION_USERS U on U.UserNo=BS.UserNo
	WHERE ContentNo = board_getsharers.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
