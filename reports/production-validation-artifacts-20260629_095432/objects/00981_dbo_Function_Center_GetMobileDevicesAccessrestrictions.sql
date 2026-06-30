-- ─── FUNCTION: center_getmobiledevicesaccessrestrictions ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getmobiledevicesaccessrestrictions(integer);
CREATE OR REPLACE FUNCTION public.center_getmobiledevicesaccessrestrictions(
    userno integer
) RETURNS TABLE(
    deviceno bigserial,
    userno integer,
    mobiletype character varying(100),
    osversion character varying(100),
    modulename character varying(100),
    deviceid character varying(1000),
    devicename character varying(100),
    uuid character varying(1000),
    enabled boolean,
    regdate timestamp without time zone
)
AS $function$
BEGIN


	RETURN QUERY
	select * from Center_MobileDevicesAccessrestrictions WHERE UserNo = center_getmobiledevicesaccessrestrictions.userno and mobileType = mobileType;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
