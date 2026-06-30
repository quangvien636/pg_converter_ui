-- ─── PROCEDURE→FUNCTION: mail_getsharedaccounts_shareduserno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getsharedaccounts_shareduserno(integer);
CREATE OR REPLACE FUNCTION public.mail_getsharedaccounts_shareduserno(
    IN shareduserno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
