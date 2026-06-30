-- ─── FUNCTION: work_updatecooperationreferenceviewbool ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updatecooperationreferenceviewbool(integer, boolean);
CREATE OR REPLACE FUNCTION public.work_updatecooperationreferenceviewbool(
    referenceno integer,
    viewbool boolean
) RETURNS void
AS $function$
BEGIN


	update Work_CooperationReference
	set ViewBool = work_updatecooperationreferenceviewbool.viewbool
	WHERE ReferenceNo = work_updatecooperationreferenceviewbool.referenceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
