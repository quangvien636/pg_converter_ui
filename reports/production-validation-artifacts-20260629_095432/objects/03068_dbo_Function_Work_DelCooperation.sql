-- ─── FUNCTION: work_delcooperation ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_delcooperation(integer);
CREATE OR REPLACE FUNCTION public.work_delcooperation(
    cooperationno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Work_Cooperation
	WHERE CooperationNo = work_delcooperation.cooperationno;
	DELETE FROM Work_CooperationComments
	WHERE CooperationNo = work_delcooperation.cooperationno;
	DELETE FROM Work_CooperationReference
	WHERE CooperationNo = work_delcooperation.cooperationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
