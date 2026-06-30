-- ─── PROCEDURE→FUNCTION: work_readcooperation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_readcooperation(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_readcooperation(
    IN cooperationno integer,
    IN userno integer,
    IN readdate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Work_CooperationReference VALUES (CooperationNo, UserNo,ReadDate,1);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
