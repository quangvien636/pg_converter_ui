-- ─── FUNCTION: center_deleteexclusionusersforotp ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deleteexclusionusersforotp(bigint);
CREATE OR REPLACE FUNCTION public.center_deleteexclusionusersforotp(
    exclusionno bigint
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Center_ExclusionUsersForOTP
	WHERE ExclusionNo = center_deleteexclusionusersforotp.exclusionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
