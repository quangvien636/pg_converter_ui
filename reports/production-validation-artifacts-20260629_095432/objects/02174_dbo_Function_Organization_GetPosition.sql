-- ─── FUNCTION: organization_getposition ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getposition(integer);
CREATE OR REPLACE FUNCTION public.organization_getposition(
    positionno integer
) RETURNS TABLE(
    positionno text,
    moduserno text,
    moddate text,
    name text,
    name_en text,
    sortno text,
    enabled text,
    name_ch text,
    name_jp text,
    name_vn text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT PositionNo, ModUserNo, ModDate, Name, Name_EN, SortNo, Enabled
	,Name_CH,Name_JP,Name_VN
	FROM Organization_Positions
	WHERE PositionNo = organization_getposition.positionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
