-- ─── PROCEDURE→FUNCTION: votemasterconfirm ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.votemasterconfirm(integer, integer);
CREATE OR REPLACE FUNCTION public.votemasterconfirm(
    IN id integer,
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE VOTEMaster SET IsReg = TRUE, ModDate = NOW(), ModUserNo = votemasterconfirm.userno WHERE ID = votemasterconfirm.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
