-- ─── FUNCTION: contacts_getranklistcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getranklistcount();
CREATE OR REPLACE FUNCTION public.contacts_getranklistcount(
) RETURNS TABLE(
    cnt text
)
AS $function$
BEGIN

	
	RETURN QUERY
	SELECT 
		COUNT(*) AS CNT
	  FROM ContactsUser U
		JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
	WHERE U.RegUserNo = UserNo
	AND UseYn = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
