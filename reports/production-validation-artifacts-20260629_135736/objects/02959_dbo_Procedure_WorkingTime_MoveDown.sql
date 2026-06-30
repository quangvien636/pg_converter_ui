-- ─── PROCEDURE→FUNCTION: workingtime_movedown ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_movedown();
CREATE OR REPLACE FUNCTION public.workingtime_movedown(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	With cte As
	(
		SELECT Sort,
		ROW_NUMBER() OVER (ORDER BY COALESCE(Sort,0) ASC, No ASC) AS RN
		FROM WorkingTime_BoxUses
	)
	--select * from cte;
	UPDATE cte SET Sort=RN;;
	UPDATE WorkingTime_BoxUses set Sort = Sort + 1.01 Where No =  p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
