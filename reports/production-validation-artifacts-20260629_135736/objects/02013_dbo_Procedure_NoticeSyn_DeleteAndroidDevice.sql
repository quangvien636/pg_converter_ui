-- ─── PROCEDURE→FUNCTION: noticesyn_deleteandroiddevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_deleteandroiddevice(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM NoticeSyn_AndroidDevices WHERE UserNo = noticesyn_deleteandroiddevice.userno
	
END;

-------------------------------/////////////////////////////-------
------USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
