-- ─── FUNCTION: contacts_search_nodistance ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_search_nodistance(integer, integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_search_nodistance(
    userno integer,
    serchtype integer,
    serchtext character varying,
    viewcount integer,
    currentpageindex integer
) RETURNS TABLE(
    groupname text
)
AS $function$
BEGIN

	IF SerchType=21
	BEGIN
		RETURN QUERY
		SELECT * FROM (SELECT
				CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
				,CONVERT(INT, ROW_NUMBER() OVER (
				ORDER BY 
					CASE WHEN SortColumn='ASC_NAME' THEN U.LastName END ASC,
					CASE WHEN SortColumn='DESC_NAME' THEN U.LastName END DESC,
					CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
					CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
					CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
					CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC
				)) AS RowNum
				,C.Company
				,C.Depart
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_search_nodistance.userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_search_nodistance.userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_search_nodistance.userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_search_nodistance.userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_search_nodistance.userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_search_nodistance.userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_search_nodistance.userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_search_nodistance.userno) S ON S.UserSeq=U.Seq
				WHERE 
				U.Seq not in (SELECT ContactUserId FROM Contacts_Locations CL WHERE CL.RegUserNo=contacts_search_nodistance.userno ) AND
				((U.LastName || ' ' || U.FirstName) ILIKE '%' || SerchText || '%' or (U.FirstName || ' ' || U.LastName) ILIKE '%' || SerchText || '%'  or C.Company ILIKE '%' || SerchText || '%' or C.Depart ILIKE '%' || SerchText || '%' or C.Position ILIKE '%' || SerchText || '%' or E.Value ILIKE '%' || SerchText || '%' or (SELECT GroupName FROM ContactsGroup WHERE G.GroupNo=GroupNo) ILIKE '%' || SerchText || '%' or A.Address ILIKE '%' || SerchText || '%')
				
				GROUP BY 
				C.Company
				,C.Depart
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
				) T
				WHERE T.RowNum
				BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
				AND CurrentPageIndex * ViewCount
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
