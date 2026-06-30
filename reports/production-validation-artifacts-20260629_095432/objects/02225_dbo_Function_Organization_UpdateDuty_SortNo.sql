-- ─── FUNCTION: organization_updateduty_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateduty_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_updateduty_sortno(
    dutyno integer,
    moduserno integer,
    moddate timestamp without time zone,
    sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Duties SET
		ModUserNo = organization_updateduty_sortno.moduserno,
		ModDate = organization_updateduty_sortno.moddate,
		SortNo = organization_updateduty_sortno.sortno
	WHERE DutyNo = organization_updateduty_sortno.dutyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
