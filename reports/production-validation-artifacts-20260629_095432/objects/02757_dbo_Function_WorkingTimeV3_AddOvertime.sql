-- ─── FUNCTION: workingtimev3_addovertime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev3_addovertime(character varying, double precision, character varying);
CREATE OR REPLACE FUNCTION public.workingtimev3_addovertime(
    p_uid character varying,
    p_v double precision,
    p_sd character varying
) RETURNS void
AS $function$
BEGIN



	insert into WorkingTimeV3_Vacations (UserNo,Overtime,StartDate,EndDate)
	values (p_uNo,p_v,p_sd,p_ed);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
