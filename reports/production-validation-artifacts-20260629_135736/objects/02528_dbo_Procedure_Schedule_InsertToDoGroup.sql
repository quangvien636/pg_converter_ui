-- ─── PROCEDURE→FUNCTION: schedule_inserttodogroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_inserttodogroup(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_inserttodogroup(
    IN reguserno integer,
    IN regdate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO ScheduleToDoGroups(RegUserNo, RegDate, ModUserNo, ModDate, Name)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate, Name)
		

	GroupNo := lastval();
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
