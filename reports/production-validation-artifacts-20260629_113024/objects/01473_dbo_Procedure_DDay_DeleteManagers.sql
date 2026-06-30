-- ─── PROCEDURE→FUNCTION: dday_deletemanagers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deletemanagers(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletemanagers(
    IN dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_Managers WHERE DayNo = dday_deletemanagers.dayno

	PERFORM dday_deletecountofappbadge(DayNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
