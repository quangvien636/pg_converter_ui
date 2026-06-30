-- ─── FUNCTION: organization_deletesortingeachdepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_deletesortingeachdepartment(integer, integer);
CREATE OR REPLACE FUNCTION public.organization_deletesortingeachdepartment(
    departno integer,
    userno integer
) RETURNS void
AS $function$
BEGIN


	IF (UserNo = 0) BEGIN

		DELETE FROM Organization_SortingEachDepartment WHERE DepartNo = organization_deletesortingeachdepartment.departno

	END

	ELSE BEGIN

		DELETE FROM Organization_SortingEachDepartment WHERE DepartNo = organization_deletesortingeachdepartment.departno AND UserNo = organization_deletesortingeachdepartment.userno

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
