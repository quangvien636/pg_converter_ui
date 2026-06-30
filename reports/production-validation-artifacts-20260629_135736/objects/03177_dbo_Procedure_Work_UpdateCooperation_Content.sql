-- ─── PROCEDURE→FUNCTION: work_updatecooperation_content ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updatecooperation_content(integer);
CREATE OR REPLACE FUNCTION public.work_updatecooperation_content(
    IN cooperationno integer
) RETURNS void
AS $function$
BEGIN


	update Work_Cooperation
	Content := Content;
	WHERE CooperationNo = work_updatecooperation_content.cooperationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
