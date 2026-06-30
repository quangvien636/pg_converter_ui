-- ─── FUNCTION: votequestionnairedel ───────────────────────────────
DROP FUNCTION IF EXISTS public.votequestionnairedel(integer);
CREATE OR REPLACE FUNCTION public.votequestionnairedel(
    id integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM VOTEQuestionnaire WHERE MasterID = votequestionnairedel.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
