-- ─── FUNCTION: mail_getsharedaccounts_shareduserno ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getsharedaccounts_shareduserno(integer);
CREATE OR REPLACE FUNCTION public.mail_getsharedaccounts_shareduserno(
    shareduserno integer
) RETURNS TABLE(
    sharedaccountno text,
    userno text,
    shareduserno text,
    departno text,
    col5 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT 
	m.SharedAccountNo,
	m.UserNo,
	m.SharedUserNo,
	m.DepartNo 
	,case when m.UserNo = 0 then d.Name else
	case when m.DepartNo = 0 then u.Name else 'N/A'  end end Name
	FROM Mail_SharedAccounts m
	left join Organization_Users u on m.UserNo = u.UserNo and m.DepartNo = 0
	left join Organization_Departments d on m.DepartNo = d.DepartNo and m.UserNo = 0
	WHERE m.SharedUserNo = mail_getsharedaccounts_shareduserno.shareduserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
