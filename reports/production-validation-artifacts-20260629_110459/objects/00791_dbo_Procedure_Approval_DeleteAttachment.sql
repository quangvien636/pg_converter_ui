-- ─── PROCEDURE→FUNCTION: approval_deleteattachment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.approval_deleteattachment(bigint);
CREATE OR REPLACE FUNCTION public.approval_deleteattachment(
    IN attachno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Approval_Attachments WHERE AttachNo = approval_deleteattachment.attachno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
