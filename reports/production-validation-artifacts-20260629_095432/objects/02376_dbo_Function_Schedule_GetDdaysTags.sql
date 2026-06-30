-- ─── FUNCTION: schedule_getddaystags ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddaystags();
CREATE OR REPLACE FUNCTION public.schedule_getddaystags(
) RETURNS TABLE(
    userno text,
    groupno text,
    groupname text,
    tagimageno text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT T.UserNo, T.GroupNo, CASE WHEN T.GroupNo = 0 THEN '미지정' ELSE G.Name END As GroupName, T.TagImageNo 
	FROM ScheduleDdaysTag T
	LEFT OUTER JOIN ScheduleDdayGroups G ON T.GroupNo = G.GroupNo
	WHERE UserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
