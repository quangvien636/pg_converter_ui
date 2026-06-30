-- ─── PROCEDURE→FUNCTION: notice_setdatenotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_setdatenotice(integer, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.notice_setdatenotice(
    IN p_no integer,
    IN p_st timestamp without time zone,
    IN p_ed timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Notices 
	PPStartDate := notice_setdatenotice.p_st,;
	PPEndDate = notice_setdatenotice.p_ed
	WHERE NoticeNo = notice_setdatenotice.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
