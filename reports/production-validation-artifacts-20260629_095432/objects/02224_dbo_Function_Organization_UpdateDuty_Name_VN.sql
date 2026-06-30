-- ─── FUNCTION: organization_updateduty_name_vn ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateduty_name_vn(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateduty_name_vn(
    dutyno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Duties SET
		ModUserNo = organization_updateduty_name_vn.moduserno,
		ModDate = organization_updateduty_name_vn.moddate,
		Name_VN = Name_VN
	WHERE DutyNo = organization_updateduty_name_vn.dutyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
