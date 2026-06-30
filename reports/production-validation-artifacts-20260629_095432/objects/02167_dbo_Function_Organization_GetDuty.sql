-- ─── FUNCTION: organization_getduty ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getduty(integer);
CREATE OR REPLACE FUNCTION public.organization_getduty(
    dutyno integer
) RETURNS TABLE(
    dutyno text,
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
	SELECT DutyNo, ModUserNo, ModDate, Name, Name_EN, SortNo, Enabled
	,Name_CH,Name_JP,Name_VN
	FROM Organization_Duties
	WHERE DutyNo = organization_getduty.dutyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
