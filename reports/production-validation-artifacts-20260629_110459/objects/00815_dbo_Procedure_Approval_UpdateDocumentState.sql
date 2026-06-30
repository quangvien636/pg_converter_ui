-- ─── PROCEDURE→FUNCTION: approval_updatedocumentstate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.approval_updatedocumentstate(bigint, integer, bigint);
CREATE OR REPLACE FUNCTION public.approval_updatedocumentstate(
    IN documentno bigint,
    IN state integer,
    IN currentappno bigint
) RETURNS void
AS $function$
BEGIN


	UPDATE Approval_Documents
	SET State = approval_updatedocumentstate.state,
		CurrentAppNo = approval_updatedocumentstate.currentappno
	WHERE DocumentNo = approval_updatedocumentstate.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
