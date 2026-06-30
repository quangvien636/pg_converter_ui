-- ─── FUNCTION: vacation_getrequest ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_getrequest(integer);
CREATE OR REPLACE FUNCTION public.vacation_getrequest(
    p_rid integer
) RETURNS TABLE(
    requestid serial,
    userno integer,
    typeid integer,
    fromd timestamp without time zone,
    tod timestamp without time zone,
    vacationscount double precision,
    note character varying(4000),
    datecreate timestamp without time zone,
    statususer integer,
    statusadmin integer,
    dateupdate timestamp without time zone
)
AS $function$
BEGIN


RETURN QUERY
select * from  Vacation_Requests 
where Vacation_Requests.RequestId = vacation_getrequest.p_rid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
