-- ─── PROCEDURE→FUNCTION: notice_setenddate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_setenddate(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.notice_setenddate(
    IN p_pchek integer,
    IN p_uno integer,
    IN p_u integer
) RETURNS void
AS $function$
BEGIN



	IF p_uid < 0 THEN;
		INSERT INTO Notice_UserPermission(UserNo,CategoryId, Permission,ModUserNo,ModDate,RegUserNo,RegDate,ViewEndDate) 
		values(p_uno,0,1,p_uno,NOW(),p_u,NOW(),p_pchek)
	END IF;

	-- -- update user is not permission
	ELSE

		update Notice_UserPermission set ViewEndDate = notice_setenddate.p_pchek
		where UserNo = notice_setenddate.p_uno
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
