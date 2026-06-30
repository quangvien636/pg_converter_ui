-- ─── PROCEDURE→FUNCTION: vacation_updaterequestepbyuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_updaterequestepbyuser(integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, double precision, integer, character varying);
CREATE OR REPLACE FUNCTION public.vacation_updaterequestepbyuser(
    IN p_type integer,
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone,
    IN p_date timestamp without time zone,
    IN p_typea integer,
    IN p_td double precision,
    IN p_uno integer,
    IN p_note character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

update Vacation_RequestEps
           
		   TypeId := vacation_updaterequestepbyuser.p_type;
           ,Fromd = vacation_updaterequestepbyuser.p_from
           ,Tod = vacation_updaterequestepbyuser.p_to
		   ,Note = vacation_updaterequestepbyuser.p_note
           , TypeForAll =vacation_updaterequestepbyuser.p_typea
		   ,TimeDis =vacation_updaterequestepbyuser.p_td
where  UsernoI = vacation_updaterequestepbyuser.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
