-- ─── PROCEDURE→FUNCTION: work_insertworkgroupperson ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_insertworkgroupperson(integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkgroupperson(
    IN groupno integer,
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkGroupPersons(GroupNo, UserNo)
	VALUES(GroupNo, UserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
