-- ─── FUNCTION: user_getdepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.user_getdepartment(integer);
CREATE OR REPLACE FUNCTION public.user_getdepartment(
    departno integer
) RETURNS TABLE(
    departno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    parentno text,
    name text,
    sortno text,
    enabled text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DepartNo, RegUserNo, RegDate, ModUserNo, ModDate, ParentNo,
		Name, SortNo, Enabled
	FROM Departments WHERE DepartNo = user_getdepartment.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
