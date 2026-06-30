-- ─── FUNCTION: contacts_getuserbypublicgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuserbypublicgroup(integer, integer, integer, integer, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getuserbypublicgroup(
    userno integer DEFAULT 70,
    groupno integer DEFAULT 8,
    viewcount integer DEFAULT 10,
    currentpageindex integer DEFAULT 1,
    initial character varying DEFAULT '',
    serchtype integer DEFAULT 0,
    serchtext character varying DEFAULT ''
) RETURNS TABLE(
    totalcount text,
    col2 text,
    company text,
    depart text,
    position text,
    seq text,
    firstname text,
    lastname text,
    reguserno text,
    memo text,
    regdate text,
    photo text,
    moddate text,
    checkdate text,
    share text,
    useyn text,
    deldate text,
    important text,
    callname text,
    isdefault text,
    fullname text,
    cellphone text,
    companyphone text,
    email text,
    regusername text
)
AS $function$
BEGIN

			WITH PhoneNumbers AS (SELECT CT.UserSeq,CT.Value ,CT.Type  ,ROW_NUMBER() OVER(PARTITION BY CT.Type, CT.UserSeq ORDER BY CT.RegDate) AS Nm FROM ContactsNumber CT ),
			--GroupUsers AS(SELECT GU.*,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.GroupNo ORDER BY GU.RegDate) AS Nm FROM Contact_PublicGroup GU),
			ContactsEmails AS(SELECT     CE.UserSeq,CE.Value,ROW_NUMBER() OVER(PARTITION BY CE.UserSeq ORDER BY CE.RegDate) AS Nm FROM ContactsEmail CE),
			ContactsCompanys AS(SELECT      C.UserSeq, C.Company, C.Depart, C.Position,ROW_NUMBER() OVER(PARTITION BY C.UserSeq ORDER BY C.RegDate) AS Nm FROM ContactsCompany C)
			RETURN QUERY
			SELECT * FROM (SELECT 
			CAST(COUNT(*) OVER() AS INT) AS TotalCount
			,CAST( ROW_NUMBER() OVER (
			ORDER BY 
				CASE WHEN SortColumn='' THEN U.LastName + U.FirstName END ASC,
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName + U.FirstName END ASC,
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName + U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName + U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_IMPORTANT' THEN U.Important END ASC,
				CASE WHEN SortColumn='DESC_IMPORTANT' THEN U.Important END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			) AS INT) RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
			,COALESCE(C.Position,'') as Position
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,COALESCE(U.Photo,'') AS Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,0 as isdefault
			,U.LastName || ' ' || U.FirstName AS FullName
			,N0.Value AS CellPhone
			,N2.Value AS CompanyPhone
			,E.Value AS Email
			,OU.Name AS RegUserName
			FROM ContactsUser U
			LEFT JOIN Contact_PublicGroupUser SG ON SG.UserSeq=U.Seq AND SG.IsDelete= FALSE
			LEFT JOIN Contact_PublicGroup G ON G.PublicGroupNo= SG.PublicGroupNo AND G.IsDelete= FALSE
			LEFT JOIN ContactsCompanys C ON C.UserSeq = U.Seq AND  C.Nm=1  
			LEFT JOIN PhoneNumbers  N0 ON N0.Type=0 AND N0.UserSeq=U.Seq AND N0.Nm=1  
			LEFT JOIN PhoneNumbers  N2 ON N2.Type=2 AND N2.UserSeq=U.Seq AND N2.Nm=1 
			LEFT JOIN ContactsEmails  E ON E.UserSeq=U.Seq AND E.Nm=1
			--LEFT JOIN GroupUsers GU ON GU.UserSeq = U.Seq AND GU.Nm=1
			--LEFT JOIN ContactsGroup G ON G.GroupNo= GU.GroupNo AND G.UseYn='Y'
			LEFT JOIN Organization_users OU ON OU.Enabled = TRUE AND  OU.UserNo=U.RegUserNo 
			WHERE (SUBSTRING(U.Share,1,3)='300')
			AND COALESCE(SG.PublicGroupNo,0)=contacts_getuserbypublicgroup.groupno
			AND U.UseYn = 'Y'
			AND (serchtext='' 
					OR (serchtext !='' AND (	   
						U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%'
						OR N0.Value ILIKE '%' || SerchText || '%' 
						OR N2.Value ILIKE '%' || SerchText || '%'
						OR C.Company ILIKE '%' || SerchText || '%'
						OR C.Depart ILIKE '%' || SerchText || '%'
						OR C.Position ILIKE '%' || SerchText || '%'
						OR E.Value ILIKE '%' || SerchText || '%'
						OR G.PublicGroupName ILIKE '%' || SerchText || '%'
						OR U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%'))
					OR (SerchType = 1 AND N0.Value ILIKE '%' || SerchText || '%' OR N2.Value ILIKE '%' || SerchText || '%')
					OR (SerchType = 2 AND C.Company ILIKE '%' || SerchText || '%')
					OR (SerchType = 3 AND C.Depart ILIKE '%' || SerchText || '%')
					OR (SerchType = 4 AND C.Position ILIKE '%' || SerchText || '%')
					OR (SerchType = 5 AND E.Value ILIKE '%' || SerchText || '%')
					OR (SerchType = 6 AND G.PublicGroupName ILIKE '%' || SerchText || '%')
					OR (SerchType = 8 AND U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%')
			)
			AND (Initial='' 
				OR REPLACE(U.LastName || ' ' || U.FirstName,' ' ,'') ILIKE Initial || '%'
				OR Initial='other' AND  (U.LastName || ' ' || U.FirstName NOT ILIKE '%[0-9]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[A-Z]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[ㄱ-ㅎ]%')
				) 
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
