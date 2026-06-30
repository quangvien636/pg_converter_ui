-- ─── FUNCTION: noticesyn_deletedivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_deletedivision(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_deletedivision(
    divisionno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM NoticeSyn_Divisions WHERE DivisionNo = noticesyn_deletedivision.divisionno
END;
--------------------////////////////////////////////////////
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
