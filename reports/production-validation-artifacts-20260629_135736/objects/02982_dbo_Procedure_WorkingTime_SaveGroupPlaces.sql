-- ─── PROCEDURE→FUNCTION: workingtime_savegroupplaces ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_savegroupplaces(character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_savegroupplaces(
    IN p_name character varying,
    IN p_nameen character varying,
    IN p_type integer,
    IN p_uno integer
) RETURNS void
AS $function$
BEGIN


insert into WorkingTime_GroupPlace(RegUserNo, RegDate, GName, GNameEn, GType)
values(p_UNo, NOW(), p_Name, p_NameEn, p_Type);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
