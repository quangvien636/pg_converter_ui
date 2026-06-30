-- ─── PROCEDURE→FUNCTION: workingtime_updategroupplace ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updategroupplace(integer, character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updategroupplace(
    IN p_gno integer,
    IN p_name character varying,
    IN p_nameen character varying,
    IN p_type integer,
    IN p_uno integer
) RETURNS void
AS $function$
BEGIN



update WorkingTime_GroupPlace 
RegUserNo := workingtime_updategroupplace.p_uno, GName = workingtime_updategroupplace.p_name, GType = workingtime_updategroupplace.p_type;
WHERE GNo = workingtime_updategroupplace.p_gno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
