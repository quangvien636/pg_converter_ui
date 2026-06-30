-- ─── FUNCTION: contacts_gethistorylist ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_gethistorylist(integer, integer, integer, integer, date, date);
CREATE OR REPLACE FUNCTION public.contacts_gethistorylist(
    currpage integer,
    pagesize integer,
    searchtype integer,
    searchday integer DEFAULT 0,
    searchdate1 date DEFAULT 'GETDATE',
    searchdate2 date DEFAULT 'GETDATE'
) RETURNS TABLE(
    rownum text,
    historyno text,
    seq text,
    firstname text,
    lastname text,
    memo text,
    moddate text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF SearchType = 1  
	BEGIN
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
	END
	ELSE
	BEGIN
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
