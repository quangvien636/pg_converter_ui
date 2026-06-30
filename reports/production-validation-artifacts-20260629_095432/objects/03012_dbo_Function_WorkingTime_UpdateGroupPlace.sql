-- ─── FUNCTION: workingtime_updategroupplace ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updategroupplace(integer, character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updategroupplace(
    p_gno integer,
    p_name character varying,
    p_nameen character varying,
    p_type integer,
    p_uno integer
) RETURNS void
AS $function$
BEGIN



update WorkingTime_GroupPlace 
set RegUserNo =workingtime_updategroupplace.p_uno, GName = workingtime_updategroupplace.p_name, GType = workingtime_updategroupplace.p_type
WHERE GNo = workingtime_updategroupplace.p_gno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
