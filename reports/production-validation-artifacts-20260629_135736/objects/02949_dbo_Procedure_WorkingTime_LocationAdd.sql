-- ─── PROCEDURE→FUNCTION: workingtime_locationadd ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_locationadd(integer, integer, integer, character varying, double precision, double precision, text);
CREATE OR REPLACE FUNCTION public.workingtime_locationadd(
    IN locationno integer,
    IN reguserno integer,
    IN moduserno integer,
    IN name character varying,
    IN latitude double precision,
    IN longitude double precision,
    IN description text
) RETURNS void
AS $function$
BEGIN

     IF LocationNo=0 THEN;
			INSERT INTO WorkingTime_Locations(RegUserNo,RegDate,ModUserNo,ModDate,Name,Latitude,Longitude,Description)
			VALUES (RegUserNo,NOW(),ModUserNo,NOW(),Name,Latitude,Longitude,Description)
		 END IF;
	ELSE;
			UPDATE WorkingTime_Locations
			ModUserNo := workingtime_locationadd.moduserno,Name=workingtime_locationadd.name,Latitude=workingtime_locationadd.latitude,Longitude=workingtime_locationadd.latitude,Description=workingtime_locationadd.description,ModDate=NOW();
			WHERE LocationNo=workingtime_locationadd.locationno
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
