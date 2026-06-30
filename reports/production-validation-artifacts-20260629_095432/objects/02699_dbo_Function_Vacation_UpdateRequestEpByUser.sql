-- ─── FUNCTION: vacation_updaterequestepbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_updaterequestepbyuser(integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, double precision, integer, character varying);
CREATE OR REPLACE FUNCTION public.vacation_updaterequestepbyuser(
    p_type integer,
    p_from timestamp without time zone,
    p_to timestamp without time zone,
    p_date timestamp without time zone,
    p_typea integer,
    p_td double precision,
    p_uno integer,
    p_note character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

update Vacation_RequestEps
           
		   set 
           TypeId = vacation_updaterequestepbyuser.p_type
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
