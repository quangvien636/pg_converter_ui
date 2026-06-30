-- ─── FUNCTION: workingtime_savegroupplaces ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_savegroupplaces(character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_savegroupplaces(
    p_name character varying,
    p_nameen character varying,
    p_type integer,
    p_uno integer
) RETURNS void
AS $function$
BEGIN


insert into WorkingTime_GroupPlace(RegUserNo, RegDate, GName, GNameEn, GType)
values(p_UNo, NOW(), p_Name, p_NameEn, p_Type);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
