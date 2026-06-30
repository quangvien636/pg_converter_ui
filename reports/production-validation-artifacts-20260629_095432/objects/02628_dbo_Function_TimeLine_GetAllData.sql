-- ─── FUNCTION: timeline_getalldata ───────────────────────────────
DROP FUNCTION IF EXISTS public.timeline_getalldata(integer, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.timeline_getalldata(
    userno integer,
    fromdate timestamp without time zone DEFAULT NULL,
    todate timestamp without time zone DEFAULT NULL
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN



	IF(fromDate is NULL)  SELECT fromDate = '1900-1-1'::timestamp 
	IF(toDate is NULL)  SELECT toDate = '5000-1-1'::timestamp 

	RETURN QUERY
	SELECT tlm.* FROM public."TimeLine_Main" tlm
	WHERE  UserNo = timeline_getalldata.userno
	AND Mode>0
	AND CONVERT(VARCHAR(20),fromDate,101)<=CONVERT(VARCHAR(20),ViewDate,101) 
	AND CONVERT(VARCHAR(20),ViewDate,101)<=CONVERT(VARCHAR(20),toDate,101)
	ORDER BY ViewDate asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
