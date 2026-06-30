-- ─── FUNCTION: workingtime_getlastbox ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlastbox(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlastbox(
    p_uno integer
) RETURNS TABLE(
    no text,
    name text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ T.bno as No, T.bname as Name
	FROM WorkingTime_Times T
	WHERE T.bno IS NOT NULL AND T.bno <> 0 AND T.RegUserNo = workingtime_getlastbox.p_uno
	ORDER BY RegDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
