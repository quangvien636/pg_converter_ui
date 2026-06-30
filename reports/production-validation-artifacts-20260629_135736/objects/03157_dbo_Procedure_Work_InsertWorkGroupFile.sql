-- ─── PROCEDURE→FUNCTION: work_insertworkgroupfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_insertworkgroupfile(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkgroupfile(
    IN historyno integer,
    IN name character varying,
    IN length integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkGroupFiles
	VALUES(HistoryNo, Name, Length);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
