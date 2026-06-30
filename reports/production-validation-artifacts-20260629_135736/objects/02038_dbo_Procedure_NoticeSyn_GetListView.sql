-- ─── PROCEDURE→FUNCTION: noticesyn_getlistview ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_getlistview(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.noticesyn_getlistview(
    IN noticeno integer,
    IN readdate timestamp without time zone
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

 RETURN QUERY
 SELECT * FROM public."NoticeSyn_Reference" 
 WHERE NoticeNo = noticesyn_getlistview.noticeno;
 -- and ReadDate=ReadDate
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
