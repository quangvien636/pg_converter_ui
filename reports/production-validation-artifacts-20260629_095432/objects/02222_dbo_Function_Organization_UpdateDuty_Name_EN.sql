-- ─── FUNCTION: organization_updateduty_name_en ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateduty_name_en(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateduty_name_en(
    dutyno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Duties SET
		ModUserNo = organization_updateduty_name_en.moduserno,
		ModDate = organization_updateduty_name_en.moddate,
		Name_EN = Name_EN
	WHERE DutyNo = organization_updateduty_name_en.dutyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
