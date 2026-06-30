-- ─── FUNCTION: organization_deletebelongtodepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_deletebelongtodepartment(bigint);
CREATE OR REPLACE FUNCTION public.organization_deletebelongtodepartment(
    belongno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Organization_BelongToDepartment WHERE BelongNo = organization_deletebelongtodepartment.belongno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
