-- ─── PROCEDURE→FUNCTION: approval_insertaccesskey ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.approval_insertaccesskey(character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_insertaccesskey(
    IN accesskey character varying,
    IN userno integer,
    IN formno integer,
    IN documentno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO ApprovalAccessKeys(AccessKey, UserNo, RegDate, FormNo, DocumentNo)
	VALUES(AccessKey, UserNo, NOW(), FormNo, DocumentNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
