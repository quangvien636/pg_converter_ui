-- ─── FUNCTION: schedule_getresourcebuygroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcebuygroup();
CREATE OR REPLACE FUNCTION public.schedule_getresourcebuygroup(
) RETURNS TABLE(
    buygroupno text,
    companyname text,
    buydate text,
    buyqty text,
    buyamount text,
    mainmanagerno text,
    mainmanagername text,
    submanagerno text,
    submanagername text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
		BuyGroupNo,
		CompanyName,
		BuyDate,
		BuyQty,
		BuyAmount,
		MainManagerNo,
		public."COMNGetUserName"(MainManagerNo) AS MainManagerName,
		SubManagerNo,
		public."COMNGetUserName"(SubManagerNo) AS SubManagerName
	FROM ScheduleResourcesBuyGroup
	WHERE BuyGroupNo = BuyGroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
