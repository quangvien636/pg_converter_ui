-- ─── FUNCTION: notice_setenddate ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_setenddate(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.notice_setenddate(
    p_pchek integer,
    p_uno integer,
    p_u integer
) RETURNS void
AS $function$
BEGIN



	IF p_uid < 0
	BEGIN;
		INSERT INTO Notice_UserPermission(UserNo,CategoryId, Permission,ModUserNo,ModDate,RegUserNo,RegDate,ViewEndDate) 
		values(p_uno,0,1,p_uno,NOW(),p_u,NOW(),p_pchek)
	END

	-- -- update user is not permission
	else 
	BEGIN

		update Notice_UserPermission set ViewEndDate = notice_setenddate.p_pchek
		where UserNo = notice_setenddate.p_uno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
