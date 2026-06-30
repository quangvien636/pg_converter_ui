-- ─── PROCEDURE→FUNCTION: dday_deleteexcludedsharer ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deleteexcludedsharer(bigint);
CREATE OR REPLACE FUNCTION public.dday_deleteexcludedsharer(
    IN datano bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_ExcludedSharers
	WHERE DataNo = dday_deleteexcludedsharer.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
