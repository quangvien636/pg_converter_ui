-- ─── PROCEDURE→FUNCTION: dday_deletenotificationbydayno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deletenotificationbydayno(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletenotificationbydayno(
    IN dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Dday_Notifications
	WHERE DayNo = dday_deletenotificationbydayno.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
