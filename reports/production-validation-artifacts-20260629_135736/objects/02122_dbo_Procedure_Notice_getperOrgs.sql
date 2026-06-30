-- ─── PROCEDURE→FUNCTION: notice_getperorgs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_getperorgs();
CREATE OR REPLACE FUNCTION public.notice_getperorgs(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- Get list departments include all childs

			RETURN QUERY
			SELECT 

				P.Id, 
				P.DeparNo,
				COALESCE(P.ViewEndDate,1) ViewEndDate,
				D.Name, 
				D.Name_EN, 
				D.Name_CH, 
				D.Name_JP, 
				D.Name_VN 
				

			FROM NoticePermissions P
				INNER JOIN Organization_Departments D ON P.DeparNo = D.DepartNo 
			WHERE P.DeparNo IS NOT NULL ORDER BY P.Id DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
