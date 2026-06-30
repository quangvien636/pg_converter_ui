-- ─── FUNCTION: schedule_ongoogle ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_ongoogle(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_ongoogle(
    p_uno integer,
    p_vl integer
) RETURNS void
AS $function$
BEGIN

if((select count(1) FROM Schedule_CancelGoogle where UNo = schedule_ongoogle.p_uno) = 0)
begin;
	INSERT INTO Schedule_CancelGoogle(UNo, GData) 
	VALUES(p_uno, P_VL)
 end
 else
 begin;
	UPDATE Schedule_CancelGoogle SET GData = schedule_ongoogle.p_vl
 end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
