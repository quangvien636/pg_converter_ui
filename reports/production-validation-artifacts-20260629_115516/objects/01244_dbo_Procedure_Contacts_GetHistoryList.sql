-- ─── PROCEDURE→FUNCTION: contacts_gethistorylist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.contacts_gethistorylist(integer, integer, integer, integer, date, date);
CREATE OR REPLACE FUNCTION public.contacts_gethistorylist(
    IN currpage integer,
    IN pagesize integer,
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
			RowNum,
			HistoryNo,
			Seq,
			FirstName,
			LastName,
			Memo,
			ModDate
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER(ORDER BY U.ModDate DESC) AS RowNum,
				U.HistoryNo,
				U.Seq,
				U.FirstName,
				U.LastName,
				U.Memo,
				U.ModDate	
			  FROM ContactsUserHistory U
			WHERE U.RegUserNo = UserNo
			AND U.ModDate >= DATEADD(dd, SearchDay, NOW())
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)
	END IF;
	ELSE
		RETURN QUERY
		SELECT 
			RowNum,
			HistoryNo,
			Seq,
			FirstName,
			LastName,
			Memo,
			ModDate
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER(ORDER BY U.ModDate DESC) AS RowNum,
				U.HistoryNo,
				U.Seq,
				U.FirstName,
				U.LastName,
				U.Memo,
				U.ModDate	
			  FROM ContactsUserHistory U
			WHERE U.RegUserNo = UserNo
			AND U.ModDate BETWEEN SearchDate1 and SearchDate2
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
