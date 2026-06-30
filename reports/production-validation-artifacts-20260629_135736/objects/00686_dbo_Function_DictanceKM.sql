-- ─── FUNCTION: dictancekm ───────────────────────────────
DROP FUNCTION IF EXISTS public.dictancekm(double precision, double precision, double precision, double precision);
CREATE OR REPLACE FUNCTION public.dictancekm(
    lat1 double precision,
    lon1 double precision,
    lat2 double precision,
    lon2 double precision
) RETURNS double precision
AS $function$
BEGIN


    RETURN ACOS(SIN(PI()*lat1/180.0)*SIN(PI()*lat2/180.0)+COS(PI()*lat1/180.0)*COS(PI()*lat2/180.0)*COS(PI()*lon2/180.0-PI()*lon1/180.0))*6371;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
