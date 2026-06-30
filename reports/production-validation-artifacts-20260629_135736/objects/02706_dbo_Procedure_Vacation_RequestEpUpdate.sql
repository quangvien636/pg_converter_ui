-- ─── PROCEDURE→FUNCTION: vacation_requestepupdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_requestepupdate(integer, integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, double precision, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_requestepupdate(
    IN p_no integer,
    IN p_type integer,
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone,
    IN p_date timestamp without time zone,
    IN p_typea integer,
    IN p_td double precision,
    IN p_uno character varying,
    IN p_dno character varying,
    IN p_note character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

update Vacation_RequestEps
           
		   TypeId := vacation_requestepupdate.p_type;
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
