-- ─── FUNCTION: workingtime_delworkingtimenotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_delworkingtimenotice(integer);
CREATE OR REPLACE FUNCTION public.workingtime_delworkingtimenotice(
    noticeno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkingTime_Notices WHERE NoticeNo = workingtime_delworkingtimenotice.noticeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
