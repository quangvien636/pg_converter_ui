-- ─── PROCEDURE→FUNCTION: vacation_moveup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_moveup(integer);
CREATE OR REPLACE FUNCTION public.vacation_moveup(
    IN p_typeid integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	With cte As
	(
		SELECT TypeId,Sort,
		ROW_NUMBER() OVER (ORDER BY COALESCE(Sort,0) ASC, DateCreate ASC) AS RN
		FROM Vacation_Types 
	)
	--select * from cte;
	UPDATE cte SET Sort=RN;;
	UPDATE Vacation_Types set Sort = Sort - 1.01 Where TypeId =  vacation_moveup.p_typeid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
