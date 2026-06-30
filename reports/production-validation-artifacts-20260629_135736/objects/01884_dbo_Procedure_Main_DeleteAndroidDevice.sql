-- ─── PROCEDURE→FUNCTION: main_deleteandroiddevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.main_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.main_deleteandroiddevice(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Main_AndroidDevices WHERE UserNo = main_deleteandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
