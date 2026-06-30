-- ─── PROCEDURE→FUNCTION: board_getdepartandpositionname ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getdepartandpositionname(integer, integer);
CREATE OR REPLACE FUNCTION public.board_getdepartandpositionname(
    IN departno integer,
    IN positionno integer
) RETURNS TABLE(departname varchar, positionname varchar)
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
 
		CREATE TEMP TABLE tmp (
				 DepartName varchar(100),
				 PositionName varchar(100)
				) ON COMMIT DROP;

		Insert into tmp values ((Select case when LanguageId = 'EN' then Dep.Name_EN else Dep.Name end from Organization_Departments as Dep where DepartNo = board_getdepartandpositionname.departno),
									(Select case when LanguageId = 'EN' then Name_EN else Name end from Organization_Positions where PositionNo = board_getdepartandpositionname.positionno));

		RETURN QUERY
		select * from tmp;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.