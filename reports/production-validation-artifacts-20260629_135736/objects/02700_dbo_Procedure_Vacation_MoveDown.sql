-- ─── PROCEDURE→FUNCTION: vacation_movedown ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_movedown(integer);
CREATE OR REPLACE FUNCTION public.vacation_movedown(
    IN p_typeid integer
) RETURNS void
AS $function$
BEGIN


	With cte As
	(
		SELECT TypeId,Sort,
		ROW_NUMBER() OVER (ORDER BY COALESCE(Sort,0) ASC, DateCreate ASC) AS RN
		FROM Vacation_Types 
	);
	UPDATE cte SET Sort=RN;;
	UPDATE Vacation_Types set Sort = Sort + 1.01 Where TypeId =  vacation_movedown.p_typeid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
