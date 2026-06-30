-- ─── FUNCTION: vacation_requestepupdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_requestepupdate(integer, integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, double precision, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_requestepupdate(
    p_no integer,
    p_type integer,
    p_from timestamp without time zone,
    p_to timestamp without time zone,
    p_date timestamp without time zone,
    p_typea integer,
    p_td double precision,
    p_uno character varying,
    p_dno character varying,
    p_note character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

update Vacation_RequestEps
           
		   set 
           TypeId = vacation_requestepupdate.p_type
           ,Fromd = vacation_requestepupdate.p_from
           ,Tod = vacation_requestepupdate.p_to
		   ,Note = vacation_requestepupdate.p_note
           , TypeForAll =vacation_requestepupdate.p_typea
		   ,TimeDis =vacation_requestepupdate.p_td
		   ,UserNo = vacation_requestepupdate.p_uno
		   ,departno = vacation_requestepupdate.p_dno
where RequestId = vacation_requestepupdate.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
