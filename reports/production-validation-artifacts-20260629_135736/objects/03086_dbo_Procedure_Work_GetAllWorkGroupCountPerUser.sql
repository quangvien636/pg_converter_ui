-- ─── PROCEDURE→FUNCTION: work_getallworkgroupcountperuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getallworkgroupcountperuser(integer, date, date, integer);
CREATE OR REPLACE FUNCTION public.work_getallworkgroupcountperuser(
    IN userno integer,
    IN startdate date,
    IN enddate date,
    IN searchtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF SearchType = 0 THEN
	
		RETURN QUERY
		SELECT COUNT(*)
		FROM (
			SELECT 0 AS IsRegular
			FROM WorkGroups WG
			INNER JOIN Works W ON W.GroupNo = WG.GroupNo
			INNER JOIN WorkJournals WJ ON WJ.WorkNo = W.WorkNo
				AND WJ.RegUserNo = work_getallworkgroupcountperuser.userno
				AND (WJ.CreationDate BETWEEN StartDate AND EndDate)
			WHERE WG.Enabled = TRUE
			GROUP BY WG.GroupNo

			UNION ALL
			SELECT 1
			FROM RegularWorkGroups RWG
			INNER JOIN RegularWorkJournals RWJ ON RWJ.GroupNo = RWG.GroupNo
				AND RWJ.RegUserNo = work_getallworkgroupcountperuser.userno
				AND (RWJ.CreationDate BETWEEN StartDate AND EndDate)
			WHERE RWG.Enabled = TRUE
			GROUP BY RWG.GroupNo
		) T
		
	END IF;
	
	ELSIF SearchType = 1 THEN
	
		RETURN QUERY
		SELECT COUNT(*)
		FROM (
			SELECT 0 AS IsRegular
			FROM WorkGroups WG
			INNER JOIN WorkGroupHistorys WGH ON WGH.HistoryNo = WG.HistoryNo
				AND WGH.Name ILIKE '%' || SearchText || '%'
			INNER JOIN Works W ON W.GroupNo = WG.GroupNo
			INNER JOIN WorkJournals WJ ON WJ.WorkNo = W.WorkNo
				AND WJ.RegUserNo = work_getallworkgroupcountperuser.userno
				AND (WJ.CreationDate BETWEEN StartDate AND EndDate)
			WHERE WG.Enabled = TRUE
			GROUP BY WG.GroupNo

			UNION ALL
			SELECT 1
			FROM RegularWorkGroups RWG
			INNER JOIN RegularWorkGroupHistorys RWGH ON RWGH.HistoryNo = RWG.HistoryNo
				AND RWGH.Name ILIKE '%' || SearchText || '%'
			INNER JOIN RegularWorkJournals RWJ ON RWJ.GroupNo = RWG.GroupNo
				AND RWJ.RegUserNo = work_getallworkgroupcountperuser.userno
				AND (RWJ.CreationDate BETWEEN StartDate AND EndDate)
			WHERE RWG.Enabled = TRUE
			GROUP BY RWG.GroupNo
		) T
		
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
