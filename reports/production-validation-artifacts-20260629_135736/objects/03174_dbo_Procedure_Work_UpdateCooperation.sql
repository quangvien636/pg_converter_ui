-- ─── PROCEDURE→FUNCTION: work_updatecooperation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_updatecooperation(integer, integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.work_updatecooperation(
    IN cooperationno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN title character varying
) RETURNS void
AS $function$
BEGIN


	update Work_Cooperation
	ModUserNo := work_updatecooperation.moduserno;
	,ModDate = work_updatecooperation.moddate
	,Title = work_updatecooperation.title
	,Content =Content
	WHERE CooperationNo = work_updatecooperation.cooperationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
