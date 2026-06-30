-- ─── FUNCTION: schedule_insertresource ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertresource(character varying, integer, boolean, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.schedule_insertresource(
    name character varying,
    userno integer,
    enabled boolean DEFAULT TRUE,
    buygroupno integer DEFAULT 0,
    description character varying DEFAULT '',
    isreservation boolean DEFAULT TRUE
) RETURNS void
AS $function$
BEGIN

	INSERT INTO ScheduleResources
	(
		CategoryNo,
		Name,
		Enabled,
		BuyGroupNo,
		Description,
		IsReservation,
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate
	)
	VALUES
	(
		CategoryNo,
		Name,
		Enabled,
		BuyGroupNo,
		Description,
		IsReservation,
		UserNo,
		NOW(),
		UserNo,
		NOW()
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
