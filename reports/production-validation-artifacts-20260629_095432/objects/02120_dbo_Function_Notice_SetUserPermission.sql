-- ─── FUNCTION: notice_setuserpermission ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_setuserpermission(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.notice_setuserpermission(
    p_uno integer,
    p_per integer,
    p_userno integer
) RETURNS void
AS $function$
BEGIN


   IF(p_count = 0)
   BEGIN;
		INSERT INTO Notice_UserPermission (UserNo, CategoryId, Permission, ModUserNo,ModDate,RegUserNo,RegDate)
		values(p_uno,0,p_per,p_userNo,NOW(),p_userNo,NOW())
	END
	ELSE
	BEGIN;
		update Notice_UserPermission set  Permission = notice_setuserpermission.p_per, ModDate=NOW(), ModUserNo = notice_setuserpermission.p_userno
		where UserNo =  notice_setuserpermission.p_uno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
