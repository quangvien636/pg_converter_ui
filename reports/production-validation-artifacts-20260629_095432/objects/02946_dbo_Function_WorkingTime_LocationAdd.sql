-- ─── FUNCTION: workingtime_locationadd ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_locationadd(integer, integer, integer, character varying, double precision, double precision, text);
CREATE OR REPLACE FUNCTION public.workingtime_locationadd(
    locationno integer,
    reguserno integer,
    moduserno integer,
    name character varying,
    latitude double precision,
    longitude double precision,
    description text
) RETURNS void
AS $function$
BEGIN

     IF LocationNo=0
		 BEGIN;
			INSERT INTO WorkingTime_Locations(RegUserNo,RegDate,ModUserNo,ModDate,Name,Latitude,Longitude,Description)
			VALUES (RegUserNo,NOW(),ModUserNo,NOW(),Name,Latitude,Longitude,Description)
		 END
	ELSE
		BEGIN;
			UPDATE WorkingTime_Locations
			SET ModUserNo=workingtime_locationadd.moduserno,Name=workingtime_locationadd.name,Latitude=workingtime_locationadd.latitude,Longitude=workingtime_locationadd.latitude,Description=workingtime_locationadd.description,ModDate=NOW()
			WHERE LocationNo=workingtime_locationadd.locationno
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
