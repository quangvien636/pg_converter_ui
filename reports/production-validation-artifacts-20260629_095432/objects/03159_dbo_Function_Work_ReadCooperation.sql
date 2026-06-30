-- ─── FUNCTION: work_readcooperation ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_readcooperation(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_readcooperation(
    cooperationno integer,
    userno integer,
    readdate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Work_CooperationReference VALUES (CooperationNo, UserNo,ReadDate,1);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
