-- ─── FUNCTION: schedule_getresourcerepairforhistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcerepairforhistory();
CREATE OR REPLACE FUNCTION public.schedule_getresourcerepairforhistory(
) RETURNS TABLE(
    repairno text,
    lastuserno text,
    lastusername text,
    startdate text,
    companyname text,
    reason text,
    reguserno text,
    regusername text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
		R.RepairNo,
		R.LastUserNo,
		public."COMNGetUserName"(R.LastUserNo) AS LastUserName,
		R.StartDate,
		R.CompanyName,
		R.Reason,
		R.RegUserNo,
		public."COMNGetUserName"(R.RegUserNo) As RegUserName
	FROM ScheduleResourcesRepair R
	WHERE R.ResourceNo = ResourceNo
	ORDER BY R.StartDate Desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
