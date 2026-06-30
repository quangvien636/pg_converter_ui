-- ─── FUNCTION: schedule_getdivisionlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getdivisionlist();
CREATE OR REPLACE FUNCTION public.schedule_getdivisionlist(
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
    color text,
    sortorder text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
		DivisionNo,
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate,
		Name,
		COALESCE(NameEn,'') AS NameEn,
		COALESCE(NameJp,'') AS NameJp,
		COALESCE(NameCh,'') AS NameCh,
		COALESCE(NameVn,'') AS NameVn,
		Color,
		coalesce(SortOrder,0) as SortOrder
	FROM ScheduleDivisions;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
