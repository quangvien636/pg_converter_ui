-- ─── FUNCTION: work_getworkgroupcountpergroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getworkgroupcountpergroup(integer);
CREATE OR REPLACE FUNCTION public.work_getworkgroupcountpergroup(
    searchtype integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	IF SearchType = 0 BEGIN

		RETURN QUERY
		SELECT COUNT(*)
		FROM WorkGroups WG
		WHERE WG.Enabled = TRUE
	
	END
	
	ELSE IF SearchType = 1 BEGIN
	
		RETURN QUERY
		SELECT COUNT(*)
		FROM WorkGroups WG
		INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
			AND WGH.Name ILIKE '%' || SearchText || '%'
		WHERE WG.Enabled = TRUE
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
