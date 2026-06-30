-- ─── FUNCTION: contacts_getuser_phoneinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuser_phoneinfo(integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_phoneinfo(
    userno integer
) RETURNS TABLE(
    cellphone text
)
AS $function$
BEGIN



	RETURN QUERY
	SELECT CellPhone FROM Organization_Users
	WHERE UserNo = contacts_getuser_phoneinfo.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
