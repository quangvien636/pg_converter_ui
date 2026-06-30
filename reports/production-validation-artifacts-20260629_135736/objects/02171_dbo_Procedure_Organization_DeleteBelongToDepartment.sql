-- ─── PROCEDURE→FUNCTION: organization_deletebelongtodepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_deletebelongtodepartment(bigint);
CREATE OR REPLACE FUNCTION public.organization_deletebelongtodepartment(
    IN belongno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Organization_BelongToDepartment WHERE BelongNo = organization_deletebelongtodepartment.belongno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
