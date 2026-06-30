-- ─── FUNCTION: work_getcooperation_cooperationno ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getcooperation_cooperationno(integer);
CREATE OR REPLACE FUNCTION public.work_getcooperation_cooperationno(
    cooperationno integer
) RETURNS TABLE(
    cooperationno serial,
    groupno integer,
    reguserno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    title character varying(200),
    content text
)
AS $function$
BEGIN


	RETURN QUERY
	select * from Work_Cooperation where CooperationNo = work_getcooperation_cooperationno.cooperationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
