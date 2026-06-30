-- ─── PROCEDURE→FUNCTION: schedule_insertresourcerepair ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertresourcerepair(integer, integer, character varying, numeric, date, character varying);
CREATE OR REPLACE FUNCTION public.schedule_insertresourcerepair(
    IN userno integer,
    IN lastuserno integer,
    IN companyname character varying,
    IN amount numeric,
    IN startdate date,
    IN reason character varying DEFAULT ''
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
	IsRepair := 1;
	WHERE ResourceNo = ResourceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
