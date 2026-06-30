-- ─── PROCEDURE→FUNCTION: center_insertholidaygroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertholidaygroup(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.center_insertholidaygroup(
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Center_HolidayGroups (ModUserNo, ModDate, Title)
	VALUES (ModUserNo, ModDate, Title)
	

	GroupNo := lastval();
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
