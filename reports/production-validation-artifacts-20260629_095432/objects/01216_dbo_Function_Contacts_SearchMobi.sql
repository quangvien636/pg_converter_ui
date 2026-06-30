-- ─── FUNCTION: contacts_searchmobi ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_searchmobi(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_searchmobi(
    userno integer,
    serchtext character varying,
    type integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM (SELECT
				CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
				,CONVERT(INT, ROW_NUMBER() OVER (
				ORDER BY 
					U.LastName ASC
				)) AS RowNum		
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_searchmobi.userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq	
				LEFT JOIN ContactsNumber CN ON CN.UserSeq=U.Seq			
				WHERE U.Seq IN (SELECT MAX(Seq) FROM ContactsUser WHERE RegUserNo=contacts_searchmobi.userno GROUP BY (FirstName+LastName)) AND
				((U.LastName || ' ' || U.FirstName) ILIKE '%' || SerchText || '%' or (U.FirstName || ' ' || U.LastName) ILIKE '%' || SerchText || '%' or CN.Value ILIKE '%' || SerchText || '%') 
			
				GROUP BY 			
				U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				) T;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
