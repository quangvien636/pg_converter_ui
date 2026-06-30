-- ─── PROCEDURE→FUNCTION: work_delcooperation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_delcooperation(integer);
CREATE OR REPLACE FUNCTION public.work_delcooperation(
    IN cooperationno integer
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
