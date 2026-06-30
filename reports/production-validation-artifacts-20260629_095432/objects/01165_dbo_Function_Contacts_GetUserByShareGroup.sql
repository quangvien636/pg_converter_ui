-- ─── FUNCTION: contacts_getuserbysharegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuserbysharegroup(integer, integer, integer, integer, character varying, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.contacts_getuserbysharegroup(
    userno integer DEFAULT 70,
    groupno integer DEFAULT 0,
    viewcount integer DEFAULT 10,
    currentpageindex integer DEFAULT 1,
    initial character varying DEFAULT '',
    serchtype integer DEFAULT 0,
    serchtext character varying DEFAULT '',
    isadmin boolean DEFAULT TRUE
) RETURNS TABLE(
    seq text
)
AS $function$
BEGIN

IF(IsAdmin = TRUE)
	BEGIN
	WITH PhoneNumbers AS (
			SELECT CT.* ,ROW_NUMBER() OVER(PARTITION BY CT.Type, CT.UserSeq ORDER BY CT.RegDate) AS Nm
			FROM ContactsNumber CT 
		),GroupUsers AS(
			SELECT GU.*,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.ShareGroupNo ORDER BY GU.RegDate) AS Nm FROM Contact_ShareGroupUser GU WHERE IsDelete= FALSE
		),
		ContactsEmails AS(
			SELECT  CE.*,ROW_NUMBER() OVER(PARTITION BY CE.UserSeq ORDER BY CE.RegDate) AS Nm FROM ContactsEmail CE
		),
		ContactsCompanys AS(
			SELECT  C.*,ROW_NUMBER() OVER(PARTITION BY C.UserSeq ORDER BY C.RegDate) AS Nm FROM ContactsCompany C
		)
		RETURN QUERY
		SELECT * FROM (SELECT 
		CAST(COUNT(*) OVER() AS INT) AS TotalCount
		,CAST( ROW_NUMBER() OVER (
		ORDER BY 
		CASE WHEN SortColumn='' THEN U.Important END DESC,
			CASE WHEN SortColumn='' THEN U.LastName + U.FirstName  END ASC,
			CASE WHEN SortColumn='ASC_NAME' THEN U.LastName + U.FirstName  END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName + U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
		) AS INT) AS RowNum
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
			LEFT JOIN GroupUsers SG ON SG.UserSeq=U.Seq  AND SG.Nm=1
			LEFT JOIN Contact_ShareGroup G ON G.ShareGroupNo= SG.ShareGroupNo AND G.IsDelete= FALSE
			LEFT JOIN ContactsCompanys C ON C.UserSeq = U.Seq AND C.Nm=1  
			LEFT JOIN PhoneNumbers  N0 ON N0.Type=0 AND N0.UserSeq=U.Seq AND N0.Nm=1  
			LEFT JOIN PhoneNumbers  N2 ON N2.Type=2 AND N2.UserSeq=U.Seq AND N2.Nm=1 
			LEFT JOIN ContactsEmails  E ON E.UserSeq=U.Seq  AND E.Nm=1

			LEFT JOIN Organization_users OU ON OU.Enabled = TRUE AND  OU.UserNo=U.RegUserNo 
			WHERE 
			--((U.RegUserNo=UserNo AND SUBSTRING(U.Share,1,3)='200' AND COALESCE(SG.ShareGroupNo,0)=GroupNo) 

			((SUBSTRING(U.Share,1,3)='200' AND COALESCE(SG.ShareGroupNo,0)=contacts_getuserbysharegroup.groupno) 
			/*OR (SUBSTRING(U.Share,1,3)='200' AND U.Seq IN (select C.Seq 
														from ContactsSharers C 
														INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo=contacts_getuserbysharegroup.userno)
			)*/
			)
			AND U.UseYn = 'Y'
			AND (serchtext='' 
				OR ( serchtext !='' AND 
				  (	   (SerchType = 0 AND 
						(U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%'
						OR (N0.Value ILIKE '%' || SerchText || '%' OR N2.Value ILIKE '%' || SerchText || '%')
						OR C.Company ILIKE '%' || SerchText || '%'
						OR C.Depart ILIKE '%' || SerchText || '%'
						OR C.Position ILIKE '%' || SerchText || '%'
						OR E.Value ILIKE '%' || SerchText || '%'
						OR G.ShareGroupName ILIKE '%' || SerchText || '%'
						OR U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%'))
					OR (SerchType = 1 AND (N0.Value ILIKE '%' || SerchText || '%' OR N2.Value ILIKE '%' || SerchText || '%'))
					OR (SerchType = 2 AND C.Company ILIKE '%' || SerchText || '%')
					OR (SerchType = 3 AND C.Depart ILIKE '%' || SerchText || '%')
					OR (SerchType = 4 AND C.Position ILIKE '%' || SerchText || '%')
					OR (SerchType = 5 AND E.Value ILIKE '%' || SerchText || '%')
					OR (SerchType = 6 AND G.ShareGroupName ILIKE '%' || SerchText || '%')
					OR (SerchType = 8 AND U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%')
				  )

				)

			    )
			AND (Initial='' 
				OR REPLACE(U.LastName || ' ' || U.FirstName,' ' ,'') ILIKE Initial || '%'
				OR Initial='other' AND  (U.LastName || ' ' || U.FirstName NOT ILIKE '%[0-9]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[A-Z]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[ㄱ-ㅎ]%')
			)  
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount;

	END 
	ELSE
	BEGIN

		WITH PhoneNumbers AS (
			SELECT CT.* ,ROW_NUMBER() OVER(PARTITION BY CT.Type, CT.UserSeq ORDER BY CT.RegDate) AS Nm
			FROM ContactsNumber CT 
		),GroupUsers AS(
			SELECT GU.*,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.ShareGroupNo ORDER BY GU.RegDate) AS Nm FROM Contact_ShareGroupUser GU WHERE IsDelete= FALSE
		),
		ContactsEmails AS(
			SELECT  CE.*,ROW_NUMBER() OVER(PARTITION BY CE.UserSeq ORDER BY CE.RegDate) AS Nm FROM ContactsEmail CE
		),
		ContactsCompanys AS(
			SELECT  C.*,ROW_NUMBER() OVER(PARTITION BY C.UserSeq ORDER BY C.RegDate) AS Nm FROM ContactsCompany C
		),
		DEPARTPERMISSION AS (
			Select ItemNo ,AllowValue,AllowAccessNo 
			FROM Contact_DepartAllowAccess BD 
			INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
			WHERE  OB.UserNo=contacts_getuserbysharegroup.userno AND OB.IsDefault= TRUE AND GroupNo=BD.ItemNo
		)
		RETURN QUERY
		SELECT * FROM (SELECT 
		CAST(COUNT(*) OVER() AS INT) AS TotalCount
		,CAST( ROW_NUMBER() OVER (
		ORDER BY 
		CASE WHEN SortColumn='' THEN U.Important END DESC,
			CASE WHEN SortColumn='' THEN U.LastName + U.FirstName  END ASC,
			CASE WHEN SortColumn='ASC_NAME' THEN U.LastName + U.FirstName  END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName + U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
		) AS INT) AS RowNum
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
			LEFT JOIN GroupUsers SG ON SG.UserSeq=U.Seq  
			LEFT JOIN DEPARTPERMISSION P ON P.ItemNo=SG.ShareGroupNo
			LEFT JOIN Contact_ShareGroup G ON G.ShareGroupNo= SG.ShareGroupNo AND G.IsDelete= FALSE
			LEFT JOIN ContactsCompanys C ON C.UserSeq = U.Seq AND C.Nm=1  
			LEFT JOIN PhoneNumbers  N0 ON N0.Type=0 AND N0.UserSeq=U.Seq AND N0.Nm=1  
			LEFT JOIN PhoneNumbers  N2 ON N2.Type=2 AND N2.UserSeq=U.Seq AND N2.Nm=1 
			LEFT JOIN ContactsEmails  E ON E.UserSeq=U.Seq  AND E.Nm=1
			LEFT JOIN Organization_users OU ON OU.Enabled = TRUE AND  OU.UserNo=U.RegUserNo 
			
			WHERE 
			((U.RegUserNo=contacts_getuserbysharegroup.userno AND SUBSTRING(U.Share,1,3)='200' AND GroupNo=0) 
			--OR (SUBSTRING(U.Share,1,3)='200' AND COALESCE(SG.ShareGroupNo,0)=GroupNo AND U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo=UserNo))
			/*OR (SUBSTRING(U.Share,1,3)='200' AND (U.RegUserNo IN (SELECT UserNo 
															FROM Organization_BelongToDepartment 
															WHERE DepartNo IN (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = contacts_getuserbysharegroup.userno))))
				*/											
			OR (SUBSTRING(U.Share,1,3) ='200' AND GroupNo=SG.ShareGroupNo AND (U.Seq IN (select C.Seq 
												from ContactsSharers  C 
												INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo = contacts_getuserbysharegroup.userno)))
															
			)
			AND U.UseYn = 'Y'
			AND (serchtext='' 
				OR ( serchtext !='' AND 
				  (	   (SerchType = 0 AND 
						(U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%'
						OR (N0.Value ILIKE '%' || SerchText || '%' OR N2.Value ILIKE '%' || SerchText || '%')
						OR C.Company ILIKE '%' || SerchText || '%'
						OR C.Depart ILIKE '%' || SerchText || '%'
						OR C.Position ILIKE '%' || SerchText || '%'
						OR E.Value ILIKE '%' || SerchText || '%'
						OR G.ShareGroupName ILIKE '%' || SerchText || '%'
						OR U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%'))
					OR (SerchType = 1 AND (N0.Value ILIKE '%' || SerchText || '%' OR N2.Value ILIKE '%' || SerchText || '%'))
					OR (SerchType = 2 AND C.Company ILIKE '%' || SerchText || '%')
					OR (SerchType = 3 AND C.Depart ILIKE '%' || SerchText || '%')
					OR (SerchType = 4 AND C.Position ILIKE '%' || SerchText || '%')
					OR (SerchType = 5 AND E.Value ILIKE '%' || SerchText || '%')
					OR (SerchType = 6 AND G.ShareGroupName ILIKE '%' || SerchText || '%')
					OR (SerchType = 8 AND U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%')
				  )

				)

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
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
