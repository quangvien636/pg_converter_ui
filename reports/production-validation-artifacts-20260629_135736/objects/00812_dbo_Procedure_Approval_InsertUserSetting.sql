-- ─── PROCEDURE→FUNCTION: approval_insertusersetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.approval_insertusersetting(integer);
CREATE OR REPLACE FUNCTION public.approval_insertusersetting(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO ApprovalUserSettings
	VALUES(UserNo, SignImage);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
