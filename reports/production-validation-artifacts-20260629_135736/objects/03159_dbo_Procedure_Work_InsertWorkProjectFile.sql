-- ─── PROCEDURE→FUNCTION: work_insertworkprojectfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_insertworkprojectfile(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkprojectfile(
    IN historyno integer,
    IN name character varying,
    IN length integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkProjectFiles
	VALUES(HistoryNo, Name, Length);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
