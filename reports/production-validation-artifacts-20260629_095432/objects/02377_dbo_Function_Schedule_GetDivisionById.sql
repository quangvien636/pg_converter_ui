-- ─── FUNCTION: schedule_getdivisionbyid ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getdivisionbyid(integer);
CREATE OR REPLACE FUNCTION public.schedule_getdivisionbyid(
    divisionno integer
) RETURNS TABLE(
    divisionno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text,
    nameen text,
    namejp text,
    namech text,
    namevn text,
    color text
)
AS $function$
BEGIN

	RETURN QUERY
	select DivisionNo,RegUserNo,RegDate,ModUserNo,ModDate,Name,NameEn,NameJp,NameCh,NameVn,Color
	from ScheduleDivisions where DivisionNo = schedule_getdivisionbyid.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
