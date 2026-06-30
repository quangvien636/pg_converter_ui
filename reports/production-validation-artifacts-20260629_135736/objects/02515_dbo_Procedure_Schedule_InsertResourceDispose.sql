-- ─── PROCEDURE→FUNCTION: schedule_insertresourcedispose ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertresourcedispose(date, integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_insertresourcedispose(
    IN disposedate date,
    IN userno integer,
    IN disposereason character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

	INSERT INTO ScheduleResourcesDispose
	(
		ResourceNo,
		DisposeDate,
		DisposeReason,
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate
	)
	VALUES
	(
		ResourceNo,
		DisposeDate,
		DisposeReason,
		UserNo,
		NOW(),
		UserNo,
		NOW()
	)
	
	UPDATE ScheduleResources
	IsDisposed := 1,;
		ModUserNo = schedule_insertresourcedispose.userno,
		ModDate = NOW()
	WHERE ResourceNo = ResourceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
