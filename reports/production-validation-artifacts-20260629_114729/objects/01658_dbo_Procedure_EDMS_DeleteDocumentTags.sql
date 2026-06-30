-- ─── PROCEDURE→FUNCTION: edms_deletedocumenttags ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edms_deletedocumenttags(bigint);
CREATE OR REPLACE FUNCTION public.edms_deletedocumenttags(
    IN documentno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM EDMS_DocumentTags
	WHERE DocumentNo = edms_deletedocumenttags.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
