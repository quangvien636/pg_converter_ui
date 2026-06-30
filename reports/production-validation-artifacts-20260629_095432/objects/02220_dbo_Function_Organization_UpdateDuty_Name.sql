-- ─── FUNCTION: organization_updateduty_name ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateduty_name(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateduty_name(
    dutyno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Duties SET
		ModUserNo = organization_updateduty_name.moduserno,
		ModDate = organization_updateduty_name.moddate,
		Name = Name
	WHERE DutyNo = organization_updateduty_name.dutyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
