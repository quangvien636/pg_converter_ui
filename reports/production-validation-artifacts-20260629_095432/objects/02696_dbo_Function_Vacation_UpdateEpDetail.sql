-- ─── FUNCTION: vacation_updateepdetail ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_updateepdetail(integer, integer, timestamp without time zone, timestamp without time zone, double precision, character varying);
CREATE OR REPLACE FUNCTION public.vacation_updateepdetail(
    p_no integer,
    p_type integer,
    p_from timestamp without time zone,
    p_to timestamp without time zone,
    p_td double precision,
    p_note character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

update Vacation_RequestEps
           
		   set 
           TypeId = vacation_updateepdetail.p_type
           ,Fromd = vacation_updateepdetail.p_from
           ,Tod = vacation_updateepdetail.p_to
		   ,Note = vacation_updateepdetail.p_note
		   ,TimeDis =vacation_updateepdetail.p_td
where  RequestId = vacation_updateepdetail.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
