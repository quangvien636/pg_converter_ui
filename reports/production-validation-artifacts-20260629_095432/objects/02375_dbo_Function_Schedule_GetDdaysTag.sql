-- ─── FUNCTION: schedule_getddaystag ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddaystag(integer);
CREATE OR REPLACE FUNCTION public.schedule_getddaystag(
    groupno integer
) RETURNS TABLE(
    userno text,
    groupno text,
    tagimageno text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT UserNo, GroupNo, TagImageNo 
	FROM ScheduleDdaysTag
	WHERE UserNo = UserNo
	AND GroupNo = schedule_getddaystag.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
