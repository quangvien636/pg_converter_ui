-- ─── FUNCTION: organization_updateduty_name_jp ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateduty_name_jp(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateduty_name_jp(
    dutyno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Duties SET
		ModUserNo = organization_updateduty_name_jp.moduserno,
		ModDate = organization_updateduty_name_jp.moddate,
		Name_JP = Name_JP
	WHERE DutyNo = organization_updateduty_name_jp.dutyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
