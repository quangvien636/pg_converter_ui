-- ─── FUNCTION: workingtime_updatesetupother ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updatesetupother(integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updatesetupother(
    p_no integer,
    p_value1 integer,
    p_value2 integer,
    p_value3 integer,
    p_value4 integer,
    p_value5 integer,
    p_value6 integer,
    p_value7 integer,
    p_value8 integer,
    p_value9 integer,
    p_value10 integer,
    p_value11 integer,
    p_value12 integer,
    p_value13 integer,
    p_value14 integer
) RETURNS void
AS $function$
BEGIN


	update  WorkingTime_SetupOther 
			set Value1 = workingtime_updatesetupother.p_value1,
				Value2 = workingtime_updatesetupother.p_value2,
				Value3 = workingtime_updatesetupother.p_value3,
				Value4 = workingtime_updatesetupother.p_value4,
				Value5 = workingtime_updatesetupother.p_value5,
				Value6 = workingtime_updatesetupother.p_value6,
				Value7 = workingtime_updatesetupother.p_value7,
				Value8 = workingtime_updatesetupother.p_value8,
				Value9 = workingtime_updatesetupother.p_value9,
				Value10 = workingtime_updatesetupother.p_value10,
				Value11 = workingtime_updatesetupother.p_value11,
				Value12 = workingtime_updatesetupother.p_value12,
				Value13 = workingtime_updatesetupother.p_value13,
				Value14 = workingtime_updatesetupother.p_value14
	where No = workingtime_updatesetupother.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
