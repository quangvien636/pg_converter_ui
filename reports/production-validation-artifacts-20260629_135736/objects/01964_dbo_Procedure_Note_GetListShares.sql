-- ─── PROCEDURE→FUNCTION: note_getlistshares ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getlistshares(uuid);
CREATE OR REPLACE FUNCTION public.note_getlistshares(
    IN listno uuid
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	WITH CTE AS(
		SELECT *,RN = ROW_NUMBER()OVER(PARTITION BY ListNo, UserShare, ShareType ORDER BY UserShare)
		  FROM Note_Share
		  WHERE ListNo = note_getlistshares.listno
	)
	RETURN QUERY
	Select * FROM CTE WHERE RN = 1

END;

RETURN QUERY
select * from Note_Share where ListNo = '00000000-0000-0000-0000-000000000000';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
