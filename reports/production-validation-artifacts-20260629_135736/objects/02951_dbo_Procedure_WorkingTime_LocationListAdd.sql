-- ─── PROCEDURE→FUNCTION: workingtime_locationlistadd ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_locationlistadd(integer, character varying, integer, character varying, double precision, double precision, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_locationlistadd(
    IN userno integer,
    IN name character varying,
    IN dayadd integer,
    IN timeadd character varying,
    IN distance double precision,
    IN lat double precision,
    IN lng double precision
) RETURNS void
AS $function$
BEGIN

	INSERT INTO WorkingTime_LocationList(name,dayadd,timeadd,distance,lat,lng,userno)
	VALUES (name,dayadd,timeadd,distance,lat,lng,userno);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
