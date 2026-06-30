-- ─── PROCEDURE→FUNCTION: schedule_updateresource ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateresource(integer, character varying, integer, boolean, boolean, integer, integer, boolean, character varying);
CREATE OR REPLACE FUNCTION public.schedule_updateresource(
    IN categoryno integer,
    IN name character varying,
    IN userno integer,
    IN enabled boolean DEFAULT TRUE,
    IN isreservation boolean DEFAULT TRUE,
    IN buygroupno integer DEFAULT 0,
    IN type integer DEFAULT 0,
    IN p_ishidenreg boolean DEFAULT FALSE,
    IN p_color character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleResources
	CategoryNo := schedule_updateresource.categoryno,;
		Name = schedule_updateresource.name,
		ModUserNo = schedule_updateresource.userno,
		ModDate = NOW(),
		Enabled = schedule_updateresource.enabled,
		Description = Description,
		IsReservation = schedule_updateresource.isreservation,
		BuyGroupNo = schedule_updateresource.buygroupno,
		Type = schedule_updateresource.type
		, IsHidenReg = schedule_updateresource.p_ishidenreg
		,Color = schedule_updateresource.p_color
	WHERE ResourceNo = ResourceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
