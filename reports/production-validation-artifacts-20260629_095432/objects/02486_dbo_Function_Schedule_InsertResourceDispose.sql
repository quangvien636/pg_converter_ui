-- ─── FUNCTION: schedule_insertresourcedispose ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertresourcedispose(date, integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_insertresourcedispose(
    disposedate date,
    userno integer,
    disposereason character varying DEFAULT ''
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
	SET
		IsDisposed = TRUE,
		ModUserNo = schedule_insertresourcedispose.userno,
		ModDate = NOW()
	WHERE ResourceNo = ResourceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
