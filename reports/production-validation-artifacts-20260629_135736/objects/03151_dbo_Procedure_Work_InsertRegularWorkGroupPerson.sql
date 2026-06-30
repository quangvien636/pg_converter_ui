-- ─── PROCEDURE→FUNCTION: work_insertregularworkgroupperson ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_insertregularworkgroupperson(integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertregularworkgroupperson(
    IN historyno integer,
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO RegularWorkGroupPersons(HistoryNo, UserNo)
	VALUES(HistoryNo, UserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
