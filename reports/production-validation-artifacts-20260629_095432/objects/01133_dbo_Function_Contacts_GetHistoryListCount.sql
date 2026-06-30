-- ─── FUNCTION: contacts_gethistorylistcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_gethistorylistcount(integer, integer, date, date);
CREATE OR REPLACE FUNCTION public.contacts_gethistorylistcount(
    searchtype integer,
    searchday integer DEFAULT 0,
    searchdate1 date DEFAULT 'GETDATE',
    searchdate2 date DEFAULT 'GETDATE'
) RETURNS TABLE(
    cnt text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	IF SearchType = 1  
	BEGIN
		RETURN QUERY
		SELECT 
			COUNT(*) AS CNT
		  FROM ContactsUserHistory U
		WHERE U.RegUserNo = UserNo
		AND U.ModDate >= DATEADD(dd, SearchDay, NOW())
	END
	ELSE
	BEGIN
		RETURN QUERY
		SELECT 
			COUNT(*) AS CNT
		  FROM ContactsUserHistory U
		WHERE U.RegUserNo = UserNo
		AND U.ModDate BETWEEN SearchDate1 AND SearchDate2
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
