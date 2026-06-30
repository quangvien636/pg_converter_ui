-- ─── PROCEDURE→FUNCTION: organization_deletesortingeachdepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_deletesortingeachdepartment(integer, integer);
CREATE OR REPLACE FUNCTION public.organization_deletesortingeachdepartment(
    IN departno integer,
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	IF UserNo = 0 THEN

		DELETE FROM Organization_SortingEachDepartment WHERE DepartNo = organization_deletesortingeachdepartment.departno

	END IF;

	ELSE BEGIN

		DELETE FROM Organization_SortingEachDepartment WHERE DepartNo = organization_deletesortingeachdepartment.departno AND UserNo = organization_deletesortingeachdepartment.userno

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
