-- ─── PROCEDURE→FUNCTION: board_getteamlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getteamlist(integer);
CREATE OR REPLACE FUNCTION public.board_getteamlist(
    IN departno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

WITH TEMP AS (
	SELECT T.DepartNo,T.Name 
	FROM  Organization_Departments T Where T.ParentNo=board_getteamlist.departno AND T.Enabled = TRUE
	UNION  ALL
	SELECT  D.DepartNo,D.Name 
	FROM  Organization_Departments D
	INNER JOIN  TEMP P ON P.DepartNo=D.ParentNo  AND D.Enabled = TRUE

)
RETURN QUERY
SELECT  *
FROM  TEMP;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
