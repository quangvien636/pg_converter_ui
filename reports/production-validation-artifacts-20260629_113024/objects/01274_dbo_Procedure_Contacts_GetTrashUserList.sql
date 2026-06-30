-- ─── PROCEDURE→FUNCTION: contacts_gettrashuserlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_gettrashuserlist(integer, integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_gettrashuserlist(
    IN userno integer DEFAULT 70,
    IN viewcount integer DEFAULT 20,
    IN currentpageindex integer DEFAULT 1,
    IN sortcolumn character varying DEFAULT 'ASC_NAME',
    IN serchtype integer DEFAULT 0
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


RETURN QUERY
SELECT --MAX(T.RowNum) TotalCnt
	  T.* 
FROM(
		select 	
			COUNT(*) OVER() AS TotalCnt
			,ROW_NUMBER() OVER (ORDER BY 
				CASE WHEN SortColumn='ASC_NAME'  THEN LastName END ASC,
				CASE WHEN SortColumn='DESC_NAME'  THEN LastName END DESC,
				CASE WHEN SortColumn='ASC_NAME'  THEN FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN Depart END DESC,
				CASE WHEN SortColumn='ASC_DELDATE' THEN DelDate END ASC,
				CASE WHEN SortColumn='DESC_DELDATE' THEN DelDate END DESC
			) AS RowNum
			,U.Seq
			,C.Company
			,C.Depart
			,C.Position		
			,U.FirstName
			,U.LastName
			,max(E.Value) Email
			,max(N.Value) Number
			,U.DelDate
 from ContactsUser U 
 left JOIN ContactsCompany C ON C.UserSeq = U.Seq -- AND C.IsDefault = TRUE
 left join ContactsEmail  E ON E.UserSeq=U.Seq -- AND E.IsDefault = TRUE
 left join ContactsNumber N ON N.UserSeq=U.Seq
 WHERE U.RegUserNo = contacts_gettrashuserlist.userno AND U.UseYn = ''
 AND
	 (( SerchType = 0
		AND ( U.FirstName ILIKE '%' || SerchText || '%' OR U.LastName ILIKE '%' || SerchText || '%' OR U.CallName ILIKE '%' || SerchText || '%')       
	 ) 
	or ( SerchType = 1
		AND N.Value ILIKE '%' || SerchText || '%'
	)
	or ( SerchType = 2
		AND E.Value ILIKE '%' || SerchText || '%'
	)
	or ( SerchType = 3
		AND (C.Company ILIKE '%' || SerchText || '%')
	)
	or ( SerchType = 4
		AND (C.Depart ILIKE '%' || SerchText || '%')
	)
	or ( SerchType = 5
		AND (C.Position ILIKE '%' || SerchText || '%')
	))
	group by U.Seq,C.Company,C.Position,LastName, FirstName, Company, Depart, DelDate
) T
 WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
ORDER BY T.RowNum;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
