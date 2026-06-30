-- ─── PROCEDURE→FUNCTION: work_updatecooperationreferenceviewbool ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updatecooperationreferenceviewbool(integer, boolean);
CREATE OR REPLACE FUNCTION public.work_updatecooperationreferenceviewbool(
    IN referenceno integer,
    IN viewbool boolean
) RETURNS void
AS $function$
BEGIN


	update Work_CooperationReference
	ViewBool := work_updatecooperationreferenceviewbool.viewbool;
	WHERE ReferenceNo = work_updatecooperationreferenceviewbool.referenceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
