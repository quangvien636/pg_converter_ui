-- ─── FUNCTION: organization_updateduty_name_ch ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateduty_name_ch(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateduty_name_ch(
    dutyno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Duties SET
		ModUserNo = organization_updateduty_name_ch.moduserno,
		ModDate = organization_updateduty_name_ch.moddate,
		Name_CH = Name_CH
	WHERE DutyNo = organization_updateduty_name_ch.dutyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
