-- ─── PROCEDURE→FUNCTION: workingtime_updatebeaconpoint ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updatebeaconpoint(integer, integer, timestamp without time zone, integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updatebeaconpoint(
    IN pointno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN locationno integer,
    IN beaconuuid character varying,
    IN beaconmajor integer,
    IN beaconminor integer
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkingTime_BeaconPoints SET 
		ModUserNo = workingtime_updatebeaconpoint.moduserno,
		ModDate = workingtime_updatebeaconpoint.moddate,
		LocationNo = workingtime_updatebeaconpoint.locationno,
		BeaconUUID = workingtime_updatebeaconpoint.beaconuuid,
		BeaconMajor = workingtime_updatebeaconpoint.beaconmajor,
		BeaconMinor = workingtime_updatebeaconpoint.beaconminor
	WHERE PointNo = workingtime_updatebeaconpoint.pointno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
