-- ─── PROCEDURE→FUNCTION: work_insertworkfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_insertworkfile(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkfile(
    IN historyno integer,
    IN name character varying,
    IN length integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkFiles
	VALUES(HistoryNo, Name, Length);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
