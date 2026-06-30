-- ─── FUNCTION: contacts_countuserpublicwithoutgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_countuserpublicwithoutgroup();
CREATE OR REPLACE FUNCTION public.contacts_countuserpublicwithoutgroup(
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT COUNT(U.seq)
	FROM  ContactsUser U
	LEFT JOIN  Contact_PublicGroupUser G ON U.Seq = G.UserSeq AND U.UseYn='Y'  AND G.IsDelete= FALSE
	WHERE SUBSTRING(U.Share,1,3)='300' AND U.UseYn = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
