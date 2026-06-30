-- ─── FUNCTION: workingtime_insertbeaconpoint ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_insertbeaconpoint(integer, timestamp without time zone, integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_insertbeaconpoint(
    moduserno integer,
    moddate timestamp without time zone,
    locationno integer,
    beaconuuid character varying,
    beaconmajor integer,
    beaconminor integer
) RETURNS TABLE(
    pointno text
)
AS $function$
DECLARE
    pointno integer;
BEGIN


	INSERT INTO WorkingTime_BeaconPoints (ModUserNo, ModDate, LocationNo, BeaconUUID, BeaconMajor, BeaconMinor)
	VALUES (ModUserNo, ModDate, LocationNo, BeaconUUID, BeaconMajor, BeaconMinor)


	SET PointNo = lastval()

	RETURN QUERY
	SELECT PointNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
