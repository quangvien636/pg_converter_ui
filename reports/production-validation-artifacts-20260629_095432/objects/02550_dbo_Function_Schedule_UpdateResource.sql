-- ─── FUNCTION: schedule_updateresource ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateresource(integer, character varying, integer, boolean, boolean, integer, integer, boolean, character varying);
CREATE OR REPLACE FUNCTION public.schedule_updateresource(
    categoryno integer,
    name character varying,
    userno integer,
    enabled boolean DEFAULT TRUE,
    isreservation boolean DEFAULT TRUE,
    buygroupno integer DEFAULT 0,
    type integer DEFAULT 0,
    p_ishidenreg boolean DEFAULT FALSE,
    p_color character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleResources
	SET
		CategoryNo = schedule_updateresource.categoryno,
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
