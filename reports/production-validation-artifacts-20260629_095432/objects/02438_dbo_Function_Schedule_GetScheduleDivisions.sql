-- ─── FUNCTION: schedule_getscheduledivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getscheduledivisions();
CREATE OR REPLACE FUNCTION public.schedule_getscheduledivisions(
) RETURNS TABLE(
    divisionno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text,
    col7 text,
    col8 text,
    col9 text,
    col10 text,
    color text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DivisionNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, COALESCE(NameEn,Name) NameEn, COALESCE(NameJp,Name) NameJp, COALESCE(NameCh,Name) NameCh, COALESCE(NameVn,Name) NameVn, Color
	FROM ScheduleDivisions;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
