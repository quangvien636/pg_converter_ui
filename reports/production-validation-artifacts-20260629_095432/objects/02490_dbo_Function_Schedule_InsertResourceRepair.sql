-- ─── FUNCTION: schedule_insertresourcerepair ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertresourcerepair(integer, integer, character varying, numeric, date, character varying);
CREATE OR REPLACE FUNCTION public.schedule_insertresourcerepair(
    userno integer,
    lastuserno integer,
    companyname character varying,
    amount numeric,
    startdate date,
    reason character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

	INSERT INTO ScheduleResourcesRepair
	(
		ResourceNo,
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate,
		LastUserNo,
		CompanyName,
		Amount,
		StartDate,
		EndDate,
		Reason,
		Status
	)
	VALUES
	(
		ResourceNo,
		UserNo,
		NOW(),
		UserNo,
		NOW(),
		LastUserNo,
		CompanyName,
		Amount,
		StartDate,
		CONVERT(DATE,'1900-01-01'),
		Reason,
		'R'
	)
	-- 자원에 수리중이라는 표시 업데이트;
	UPDATE ScheduleResources
	SET
		IsRepair = TRUE
	WHERE ResourceNo = ResourceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
