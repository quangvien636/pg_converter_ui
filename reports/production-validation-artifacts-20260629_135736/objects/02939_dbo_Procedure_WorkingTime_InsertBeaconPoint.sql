-- ─── PROCEDURE→FUNCTION: workingtime_insertbeaconpoint ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_insertbeaconpoint(integer, timestamp without time zone, integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_insertbeaconpoint(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN locationno integer,
    IN beaconuuid character varying,
    IN beaconmajor integer,
    IN beaconminor integer
) RETURNS SETOF record
AS $function$
DECLARE
    pointno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO WorkingTime_BeaconPoints (ModUserNo, ModDate, LocationNo, BeaconUUID, BeaconMajor, BeaconMinor)
	VALUES (ModUserNo, ModDate, LocationNo, BeaconUUID, BeaconMajor, BeaconMinor)


	PointNo := lastval();
	RETURN QUERY
	SELECT PointNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
