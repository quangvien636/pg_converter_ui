-- ─── PROCEDURE→FUNCTION: contacts_gethistorylistcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.contacts_gethistorylistcount(integer, integer, date, date);
CREATE OR REPLACE FUNCTION public.contacts_gethistorylistcount(
    IN searchtype integer,
    IN searchday integer DEFAULT 0,
    IN searchdate1 date DEFAULT 'GETDATE',
    IN searchdate2 date DEFAULT 'GETDATE'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	IF SearchType = 1 THEN
		RETURN QUERY
		SELECT 
			COUNT(*) AS CNT
		  FROM ContactsUserHistory U
		WHERE U.RegUserNo = UserNo
		AND U.ModDate >= DATEADD(dd, SearchDay, NOW())
	END IF;
	ELSE
		RETURN QUERY
		SELECT 
			COUNT(*) AS CNT
		  FROM ContactsUserHistory U
		WHERE U.RegUserNo = UserNo
		AND U.ModDate BETWEEN SearchDate1 AND SearchDate2
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
