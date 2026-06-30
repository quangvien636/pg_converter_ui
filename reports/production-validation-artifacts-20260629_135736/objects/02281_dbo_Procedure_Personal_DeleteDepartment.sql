-- ─── PROCEDURE→FUNCTION: personal_deletedepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.personal_deletedepartment(integer);
CREATE OR REPLACE FUNCTION public.personal_deletedepartment(
    IN seq integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM BelongToDepartment WHERE UserNo = UserNo AND Seq = personal_deletedepartment.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
