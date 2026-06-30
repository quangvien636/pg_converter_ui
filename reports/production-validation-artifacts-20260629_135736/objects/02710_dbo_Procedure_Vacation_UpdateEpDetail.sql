-- ─── PROCEDURE→FUNCTION: vacation_updateepdetail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_updateepdetail(integer, integer, timestamp without time zone, timestamp without time zone, double precision, character varying);
CREATE OR REPLACE FUNCTION public.vacation_updateepdetail(
    IN p_no integer,
    IN p_type integer,
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone,
    IN p_td double precision,
    IN p_note character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

update Vacation_RequestEps
           
		   TypeId := vacation_updateepdetail.p_type;
           ,Fromd = vacation_updateepdetail.p_from
           ,Tod = vacation_updateepdetail.p_to
		   ,Note = vacation_updateepdetail.p_note
		   ,TimeDis =vacation_updateepdetail.p_td
where  RequestId = vacation_updateepdetail.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
