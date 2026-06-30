-- ─── PROCEDURE→FUNCTION: dday_deletenotificationfromddayno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deletenotificationfromddayno(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletenotificationfromddayno(
    IN ddayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_Notifications WHERE DayNo = dday_deletenotificationfromddayno.ddayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
