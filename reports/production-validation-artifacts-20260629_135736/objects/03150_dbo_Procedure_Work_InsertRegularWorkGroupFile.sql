-- ─── PROCEDURE→FUNCTION: work_insertregularworkgroupfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_insertregularworkgroupfile(bigint, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.work_insertregularworkgroupfile(
    IN fileno bigint,
    IN historyno integer,
    IN name character varying,
    IN length integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO RegularWorkGroupFiles
	VALUES(FileNo, HistoryNo, Name, Length);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
