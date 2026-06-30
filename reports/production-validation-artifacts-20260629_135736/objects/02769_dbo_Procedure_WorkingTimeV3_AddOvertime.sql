-- ─── PROCEDURE→FUNCTION: workingtimev3_addovertime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtimev3_addovertime(character varying, double precision, character varying);
CREATE OR REPLACE FUNCTION public.workingtimev3_addovertime(
    IN p_uid character varying,
    IN p_v double precision,
    IN p_sd character varying
) RETURNS void
AS $function$
BEGIN



	insert into WorkingTimeV3_Vacations (UserNo,Overtime,StartDate,EndDate)
	values (p_uNo,p_v,p_sd,p_ed);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
