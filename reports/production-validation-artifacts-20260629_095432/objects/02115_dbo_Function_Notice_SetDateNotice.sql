-- ─── FUNCTION: notice_setdatenotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_setdatenotice(integer, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.notice_setdatenotice(
    p_no integer,
    p_st timestamp without time zone,
    p_ed timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Notices 
	SET PPStartDate = notice_setdatenotice.p_st,
	PPEndDate = notice_setdatenotice.p_ed
	WHERE NoticeNo = notice_setdatenotice.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
