-- ─── FUNCTION: schedule_getresourcesetup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcesetup();
CREATE OR REPLACE FUNCTION public.schedule_getresourcesetup(
) RETURNS TABLE(
    userno text,
    viewtype text,
    viewcount text,
    startweek text,
    rsvnmethod text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    col10 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
		UserNo,
		ViewType,
		ViewCount,
		StartWeek,
		RsvnMethod,
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate,
		COALESCE(can,0) can
	FROM ScheduleResourceSetup
	WHERE UserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
