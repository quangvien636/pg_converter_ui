-- ─── FUNCTION: authority_listmodulepermission ───────────────────────────────
DROP FUNCTION IF EXISTS public.authority_listmodulepermission(integer);
CREATE OR REPLACE FUNCTION public.authority_listmodulepermission(
    applicationno integer
) RETURNS TABLE(
    modulepermissionno text,
    applicationno text,
    col3 text,
    col4 text,
    userofdepart text,
    reguserno text,
    regdate text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT ModulePermissionNo,ApplicationNo,
	case when UserofDepart = 'user' then B.UserNo else B.DepartNo end Code
	,case when UserofDepart = 'user' then U.Name else D.Name end Name
	,UserofDepart,RegUserNo,RegDate 
	FROM Authority_ModulePermission B
	LEFT JOIN Organization_Users U ON U.UserNo = B.UserNo and B.UserofDepart = 'user'
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo and B.UserofDepart = 'depart'
	WHERE ApplicationNo = authority_listmodulepermission.applicationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
