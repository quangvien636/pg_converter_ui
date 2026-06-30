-- ─── PROCEDURE→FUNCTION: schedule_insertresource ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertresource(character varying, integer, boolean, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.schedule_insertresource(
    IN name character varying,
    IN userno integer,
    IN enabled boolean DEFAULT TRUE,
    IN buygroupno integer DEFAULT 0,
    IN description character varying DEFAULT '',
    IN isreservation boolean DEFAULT TRUE
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
