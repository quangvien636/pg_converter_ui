-- ─── FUNCTION: center_deleteexclusionusersforipfilter ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deleteexclusionusersforipfilter(bigint);
CREATE OR REPLACE FUNCTION public.center_deleteexclusionusersforipfilter(
    exclusionno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Center_ExclusionUsersForIPFilter
	WHERE ExclusionNo = center_deleteexclusionusersforipfilter.exclusionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
