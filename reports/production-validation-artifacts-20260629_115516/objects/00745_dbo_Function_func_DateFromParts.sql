-- ─── FUNCTION: func_datefromparts ───────────────────────────────
DROP FUNCTION IF EXISTS public.func_datefromparts(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.func_datefromparts(
    year integer,
    month integer,
    dayofmonth integer,
    hour integer DEFAULT 0,
    sec integer DEFAULT 0
) RETURNS timestamp without time zone
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


    RETURN DATEADD(second, Sec, 
            DATEADD(minute, Min, 
            DATEADD(hour, Hour,
            DATEADD(day, DayOfMonth - 1, 
            DATEADD(month, Month - 1, 
            DATEADD(Year, Year-1900, 0))))));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
