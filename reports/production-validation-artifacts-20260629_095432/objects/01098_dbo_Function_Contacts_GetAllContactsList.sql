-- ─── FUNCTION: contacts_getallcontactslist ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getallcontactslist(integer);
CREATE OR REPLACE FUNCTION public.contacts_getallcontactslist(
    userno integer
) RETURNS TABLE(
    seq text,
    firstname text,
    lastname text,
    value text,
    position text,
    company text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT U.Seq,
		COALESCE(U.FirstName, '') AS FirstName,
		COALESCE(U.LastName, '') AS LastName,
		COALESCE(E.Value, '') AS Value,
		COALESCE(C.Position, '') AS Position,
		COALESCE(C.Company, '') AS Company
	FROM ContactsUser U
	INNER JOIN ContactsEmail E ON E.UserSeq = U.Seq
	LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq
	WHERE (U.RegUserNo = contacts_getallcontactslist.userno or SUBSTRING(U.Share,1,3) = 300)  AND U.UseYn = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
