-- ─── PROCEDURE→FUNCTION: schedule_ongoogle ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_ongoogle(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_ongoogle(
    IN p_uno integer,
    IN p_vl integer
) RETURNS void
AS $function$
BEGIN

if((select count(1) FROM Schedule_CancelGoogle where UNo = schedule_ongoogle.p_uno) = 0)
begin;
	INSERT INTO Schedule_CancelGoogle(UNo, GData) 
	VALUES(p_uno, P_VL)
 END;
 ELSE;
	UPDATE Schedule_CancelGoogle SET GData = schedule_ongoogle.p_vl
 END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
