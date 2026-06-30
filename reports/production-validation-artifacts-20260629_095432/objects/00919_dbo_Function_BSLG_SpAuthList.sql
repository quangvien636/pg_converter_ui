-- ─── FUNCTION: bslg_spauthlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_spauthlist(character varying);
CREATE OR REPLACE FUNCTION public.bslg_spauthlist(
    userid character varying
) RETURNS TABLE(
    permissionno text,
    shareduserid text,
    shareddepartno text,
    col4 text,
    userofdepart text,
    reguserno text,
    regdate text
)
AS $function$
BEGIN
	RETURN QUERY
	SELECT PermissionNo,
	SharedUserId,
	SharedDepartNo,
	case when UserofDepart = 'user' then U.Name else D.Name end Name
	,UserofDepart,RegUserNo,RegDate 
	FROM BSLG_SpAuthInfo B
	LEFT JOIN Organization_Users U ON U.UserID = B.SharedUserId and B.UserofDepart = 'user'
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.SharedDepartNo
	where B.UserId = bslg_spauthlist.userid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
