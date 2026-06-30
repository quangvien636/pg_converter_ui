-- ─── FUNCTION: vacation_updatetype ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_updatetype(integer, integer, integer, double precision, character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.vacation_updatetype(
    p_id integer,
    p_typei integer,
    p_time integer,
    p_timed double precision,
    p_name character varying DEFAULT '',
    p_note character varying DEFAULT '',
    p_offtype integer DEFAULT -1,
    p_special integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

update  Vacation_Types
set
		   Name = vacation_updatetype.p_name
           ,Typei = vacation_updatetype.p_typei
           ,Time = vacation_updatetype.p_time
           ,TimeDis = vacation_updatetype.p_timed
		   ,Note = vacation_updatetype.p_note
		   ,OffType = vacation_updatetype.p_offtype
		   ,special = vacation_updatetype.p_special
     WHERE TypeId = vacation_updatetype.p_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
