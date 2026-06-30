-- ─── PROCEDURE→FUNCTION: votejoincheck ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.votejoincheck(integer, integer);
CREATE OR REPLACE FUNCTION public.votejoincheck(
    IN id integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- Check
	RETURN QUERY
	SELECT SUM(Cnt) Cnt
	FROM
	(
		SELECT CASE WHEN NOT EXISTS (SELECT * FROM VOTEQuestionnaire WHERE MasterID = votejoincheck.id) THEN 1 ELSE 0 END Cnt
		UNION ALL
			SELECT COUNT(*) Cnt 
			FROM VOTEQuestionnaire 
			WHERE MasterID = votejoincheck.id AND Type = 'U' AND No = votejoincheck.userno
		UNION ALL
			SELECT COUNT(*) Cnt
			FROM VOTEQuestionnaire 
			WHERE MasterID = votejoincheck.id AND Type = 'EG' AND No IN
			(
				SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = votejoincheck.userno
			)
		UNION ALL
			SELECT COUNT(*) Cnt
			FROM VOTEQuestionnaire 
			WHERE MasterID = votejoincheck.id AND Type = 'UG' AND No IN
			(
				SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo = votejoincheck.userno
			)
	) R1;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
