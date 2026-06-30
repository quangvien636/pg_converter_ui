-- ─── FUNCTION: work_updatecooperation_content ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updatecooperation_content(integer);
CREATE OR REPLACE FUNCTION public.work_updatecooperation_content(
    cooperationno integer
) RETURNS void
AS $function$
BEGIN


	update Work_Cooperation
	set Content =Content
	WHERE CooperationNo = work_updatecooperation_content.cooperationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
