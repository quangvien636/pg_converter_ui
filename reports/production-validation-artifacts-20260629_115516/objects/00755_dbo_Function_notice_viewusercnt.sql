-- ─── FUNCTION: notice_viewusercnt ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_viewusercnt(integer, integer);
CREATE OR REPLACE FUNCTION public.notice_viewusercnt(
    p_noticeno integer,
    p_userno integer
) RETURNS integer
AS $function$
BEGIN



	IF(p_userno <> 0)
	begin
		SELECT p_userid = UserId FROM Organization_Users WHERE Userno = notice_viewusercnt.p_userno
		select result = COUNT(*) FROM NoticeReference WHERE NoticeNo = notice_viewusercnt.p_noticeno AND Userid = p_userid
	end;
	IF(p_userno = 0)
	begin
		select result = COUNT(*) FROM NoticeReference WHERE NoticeNo = notice_viewusercnt.p_noticeno
	end
	return result;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
