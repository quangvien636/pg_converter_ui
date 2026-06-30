-- ─── FUNCTION: schedule_getresourcedisposeforhistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcedisposeforhistory();
CREATE OR REPLACE FUNCTION public.schedule_getresourcedisposeforhistory(
) RETURNS TABLE(
    disposeno text,
    disposedate text,
    disposereason text,
    reguserno text,
    regusername text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
		DisposeNo,
		DisposeDate,
		DisposeReason,
		RegUserNo,
		public."COMNGetUserName"(RegUserNo) As RegUserName
	FROM ScheduleResourcesDispose
	WHERE ResourceNo = ResourceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
