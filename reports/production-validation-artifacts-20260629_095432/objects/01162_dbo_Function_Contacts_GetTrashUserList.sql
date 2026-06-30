-- ─── FUNCTION: contacts_gettrashuserlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_gettrashuserlist(integer, integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_gettrashuserlist(
    userno integer DEFAULT 70,
    viewcount integer DEFAULT 20,
    currentpageindex integer DEFAULT 1,
    sortcolumn character varying DEFAULT 'ASC_NAME',
    serchtype integer DEFAULT 0
) RETURNS TABLE(
    totalcnt text,
    rownum text,
    seq text,
    company text,
    depart text,
    position text,
    firstname text,
    lastname text,
    col9 text,
    col10 text,
    deldate text
)
AS $function$
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
