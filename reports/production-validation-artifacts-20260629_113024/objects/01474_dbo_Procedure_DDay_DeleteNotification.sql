-- ─── PROCEDURE→FUNCTION: dday_deletenotification ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deletenotification(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletenotification(
    IN notino bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_Notifications WHERE NotiNo = dday_deletenotification.notino;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
