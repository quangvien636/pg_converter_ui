-- ─── PROCEDURE→FUNCTION: bslg_getschmlog ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getschmlog(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getschmlog(
    IN userid character varying,
    IN date character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT SM.Seq, Title, Content, Writer, OpenType, Divide, Kind, smsYN,  smsSDate, StartDate, StartTime, LMonth, EndDate, LWeekSeq, EndTime,  LWeek, LDaily
	FROM schmmaster SM 
	WHERE EndDate >= bslg_getschmlog.date and StartDate <= bslg_getschmlog.date and  Divide ILIKE '%S%' AND Writer = bslg_getschmlog.userid
	Order by StartTime;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
