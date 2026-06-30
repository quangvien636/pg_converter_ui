-- ─── PROCEDURE→FUNCTION: vacation_gettypes ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_gettypes();
CREATE OR REPLACE FUNCTION public.vacation_gettypes(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT  t.TypeId
      ,t.UserNo
      ,t.Name
      ,t.Typei
      ,t.Time
      ,t.TimeDis
      ,t.DateCreate
      ,t.statusr
	  , t.Note
	  , t.Sort
	  , COALESCE(OffType,-1) OffType
	  , COALESCE(t.special,0) Special
  FROM Vacation_Types t order by t.Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
