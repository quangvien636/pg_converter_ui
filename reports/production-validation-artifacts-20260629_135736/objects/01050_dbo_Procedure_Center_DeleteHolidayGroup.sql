-- ─── PROCEDURE→FUNCTION: center_deleteholidaygroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deleteholidaygroup(integer);
CREATE OR REPLACE FUNCTION public.center_deleteholidaygroup(
    IN groupno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_HolidayGroups WHERE GroupNo = center_deleteholidaygroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
