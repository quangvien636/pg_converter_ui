-- ─── PROCEDURE→FUNCTION: contacts_getuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getuser(integer, integer, integer, integer, character varying, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getuser(
    IN userno integer DEFAULT 70,
    IN groupno integer DEFAULT 0,
    IN currentpageindex integer DEFAULT 1,
    IN pagesize integer DEFAULT 20,
    IN sortcolumn character varying DEFAULT '',
    IN serchtype integer DEFAULT 0,
    IN serchtext character varying DEFAULT '',
    IN initial character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

IF GroupNo=0 THEN
        RETURN QUERY
        WITH PhoneNumbers AS (
			SELECT CT.UserSeq,CT.Value ,CT.Type ,ROW_NUMBER() OVER(PARTITION BY CT.Type, CT.UserSeq ORDER BY CT.RegDate) AS Nm
			FROM ContactsNumber CT
		),
	    GroupUsers AS(
			SELECT GU.UserSeq,GU.GroupNo,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.GroupNo ORDER BY GU.RegDate) AS Nm FROM ContactsGroupUser GU
		),
	    ContactsEmails AS(SELECT   CE.UserSeq,CE.Value,ROW_NUMBER() OVER(PARTITION BY CE.UserSeq ORDER BY CE.RegDate) AS Nm FROM ContactsEmail CE),
		ContactsCompanys AS(SELECT  C.UserSeq, C.Company, C.Depart, C.Position,ROW_NUMBER() OVER(PARTITION BY C.UserSeq ORDER BY C.RegDate) AS Nm FROM ContactsCompany C)
        SELECT  * FROM (
			SELECT
			CAST(COUNT(*) OVER() as INT) AS TotalCount,
			CAST(ROW_NUMBER() OVER (
				ORDER BY
				CASE WHEN SortColumn='' THEN U.Important END DESC,
				CASE WHEN SortColumn='' THEN U.LastName + U.FirstName  END ASC,
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName + U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName + U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_IMPORTANT' THEN U.Important END ASC,
				CASE WHEN SortColumn='DESC_IMPORTANT' THEN U.Important END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC

			) as INT ) AS RowNum,
			COALESCE(C.Company,'') as Company,
			COALESCE(C.Depart,'') as Depart,
			COALESCE(C.Position,'') as Position,
			U.Seq,
			U.FirstName,
			U.LastName,
			U.RegUserNo,
			U.Memo,U.RegDate,COALESCE(U.Photo,'') AS Photo,U.ModDate,U.CheckDate,U.Share,U.UseYn,
			U.DelDate,U.Important,U.CallName,G.IsDefault,U.LastName || ' ' || U.FirstName AS FullName,
			N0.Value AS CellPhone,N2.Value AS CompanyPhone, N3.Value AS FaxPhone,
			E.Value AS Email,OU.Name AS RegUserName
			FROM ContactsUser U
			LEFT JOIN ContactsCompanys C ON C.UserSeq = U.Seq AND C.Nm=1
			LEFT JOIN PhoneNumbers  N0 ON N0.Type=0 AND N0.UserSeq=U.Seq AND N0.Nm=1
			LEFT JOIN PhoneNumbers  N2 ON N2.Type=2 AND N2.UserSeq=U.Seq AND N2.Nm=1
			LEFT JOIN PhoneNumbers  N3 ON N3.Type=3 AND N3.UserSeq=U.Seq AND N3.Nm=1
			LEFT JOIN ContactsEmails  E ON E.UserSeq=U.Seq AND E.Nm=1
			LEFT JOIN GroupUsers GU ON GU.UserSeq = U.Seq AND GU.Nm=1
			LEFT JOIN ContactsGroup G ON G.GroupNo= GU.GroupNo AND G.UseYn='Y'
			LEFT JOIN Organization_users OU ON OU.Enabled = TRUE AND  OU.UserNo=U.RegUserNo
			WHERE (U.RegUserNo = contacts_getuser.userno
				OR (U.Share='300'  AND U.RegUserNo <> contacts_getuser.userno)
				OR (SUBSTRING(U.Share,1,3)='200' AND U.RegUserNo IN (SELECT UserNo
																	 FROM Organization_BelongToDepartment
																     WHERE DepartNo IN (SELECT DepartNo
																						FROM Organization_BelongToDepartment
																						WHERE UserNo = contacts_getuser.userno)
																	)
												 AND (U.Seq IN (select C.Seq
																from ContactsSharers  C
																INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo = contacts_getuser.userno))
																	)) --and (U.Seq IN (select C.Seq from ContactsSharers  C INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo = UserNo))))
			AND U.UseYn = 'Y'
			AND (serchtext=''
					OR (serchtext !='' AND (
						U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%'
						OR N0.Value ILIKE '%' || SerchText || '%'
						OR N2.Value ILIKE '%' || SerchText || '%'
						OR N3.Value ILIKE '%' || SerchText || '%'
						OR C.Company ILIKE '%' || SerchText || '%'
						OR C.Depart ILIKE '%' || SerchText || '%'
						OR C.Position ILIKE '%' || SerchText || '%'
						OR E.Value ILIKE '%' || SerchText || '%'
						OR G.GroupName ILIKE '%' || SerchText || '%'
						OR U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%'))
					OR (SerchType = 1 AND N0.Value ILIKE '%' || SerchText || '%' OR N2.Value ILIKE '%' || SerchText || '%')
					OR (SerchType = 2 AND C.Company ILIKE '%' || SerchText || '%')
					OR (SerchType = 3 AND C.Depart ILIKE '%' || SerchText || '%')
					OR (SerchType = 4 AND C.Position ILIKE '%' || SerchText || '%')
					OR (SerchType = 5 AND E.Value ILIKE '%' || SerchText || '%')
					OR (SerchType = 6 AND G.GroupName ILIKE '%' || SerchText || '%')
					OR (SerchType = 8 AND U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%')
			)
			AND (Initial=''
				OR REPLACE(U.LastName || ' ' || U.FirstName,' ' ,'') ILIKE Initial || '%'
				OR Initial='other' AND  (U.LastName || ' ' || U.FirstName NOT ILIKE '%[0-9]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[A-Z]%' OR U.LastName || ' ' || U.FirstName NOT ILIKE '%[ㄱ-ㅎ]%')
				)
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * PageSize) + 1
			AND CurrentPageIndex * PageSize
			ORDER BY T.RowNum
			;
ELSE
BEGIN
	RETURN QUERY
	WITH PhoneNumbers AS (	SELECT CT.UserSeq,CT.Value ,CT.Type ,ROW_NUMBER() OVER(PARTITION BY CT.Type, CT.UserSeq ORDER BY CT.RegDate) AS Nm FROM ContactsNumber CT  ),
		GroupUsers AS(SELECT GU.UserSeq,GU.GroupNo,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.GroupNo ORDER BY GU.RegDate) AS Nm FROM ContactsGroupUser GU),
		ContactsEmails AS(SELECT  CE.UserSeq,CE.Value,ROW_NUMBER() OVER(PARTITION BY CE.UserSeq ORDER BY CE.RegDate) AS Nm FROM ContactsEmail CE),
		ContactsCompanys AS(SELECT  C.UserSeq, C.Company, C.Depart, C.Position,ROW_NUMBER() OVER(PARTITION BY C.UserSeq ORDER BY C.RegDate) AS Nm FROM ContactsCompany C)
	SELECT * FROM (SELECT
		CAST(COUNT(*) OVER() AS INT) AS TotalCount,
		CAST( ROW_NUMBER() OVER (
		ORDER BY
			CASE WHEN SortColumn='' THEN U.Important END DESC,
			CASE WHEN SortColumn='' THEN U.LastName + U.FirstName  END ASC,
			CASE WHEN SortColumn='ASC_NAME' THEN U.LastName + U.FirstName END ASC,
			CASE WHEN SortColumn='DESC_NAME' THEN U.LastName + U.FirstName  END DESC,
			CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
			CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
			CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
			CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
			CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
		) AS INT) AS RowNum,
		COALESCE(C.Company,'') AS Company,
		COALESCE(C.Depart,'')  AS Depart,
		COALESCE(C.Position,'') AS Position,
		U.Seq,
		U.FirstName,U.LastName,U.RegUserNo,U.Memo,U.RegDate,COALESCE(U.Photo,'') AS Photo,
		U.ModDate,
		U.CheckDate,
		U.Share,
		U.UseYn,
		U.DelDate,
		U.Important,
		U.CallName,
		CAST('0' AS char) AS IsDefault,
		U.LastName || ' ' || U.FirstName AS FullName,
		N0.Value AS CellPhone,
		N2.Value AS CompanyPhone,
		N3.Value AS FaxPhone,
		E.Value AS Email,
		OU.Name AS RegUserName
	FROM ContactsUser U
	LEFT JOIN ContactsCompanys C ON C.UserSeq = U.Seq AND C.Nm=1
	LEFT JOIN PhoneNumbers  N0 ON N0.Type=0 AND N0.UserSeq=U.Seq AND N0.Nm=1
	LEFT JOIN PhoneNumbers  N2 ON N2.Type=2 AND N2.UserSeq=U.Seq AND N2.Nm=1
	LEFT JOIN PhoneNumbers  N3 ON N3.Type=3 AND N3.UserSeq=U.Seq AND N3.Nm=1
	LEFT JOIN ContactsEmails  E ON E.UserSeq=U.Seq AND E.Nm=1
	INNER JOIN GroupUsers GU ON GU.UserSeq = U.Seq AND GU.Nm=1
	LEFT JOIN ContactsGroup G ON G.GroupNo= GU.GroupNo AND G.UseYn='Y'
	LEFT JOIN Organization_users OU ON OU.Enabled = TRUE AND   OU.UserNo=U.RegUserNo
	WHERE  GU.GroupNo IN (select * from Contacts_GetChildGroupByGroupNo(GroupNo))
	AND U.UseYn = 'Y'
	AND (Initial='' OR REPLACE(U.LastName || ' ' || U.FirstName,' ' ,'') ILIKE Initial || '%')
		AND (serchtext=''
		OR (serchtext !='' AND
			(SerchType = 0 AND
				(U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%'
				OR N0.Value ILIKE '%' || SerchText || '%'
				OR N2.Value ILIKE '%' || SerchText || '%'
				OR N3.Value ILIKE '%' || SerchText || '%'
				OR C.Company ILIKE '%' || SerchText || '%'
				OR C.Depart ILIKE '%' || SerchText || '%'
				OR C.Position ILIKE '%' || SerchText || '%'
				OR E.Value ILIKE '%' || SerchText || '%'
				OR G.GroupName ILIKE '%' || SerchText || '%'
				OR U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%'))
			OR (SerchType = 1 AND (N0.Value ILIKE '%' || SerchText || '%' OR N2.Value ILIKE '%' || SerchText || '%'))
			OR (SerchType = 2 AND C.Company ILIKE '%' || SerchText || '%')
			OR (SerchType = 3 AND C.Depart ILIKE '%' || SerchText || '%')
			OR (SerchType = 4 AND C.Position ILIKE '%' || SerchText || '%')
			OR (SerchType = 5 AND E.Value ILIKE '%' || SerchText || '%')
			OR (SerchType = 6 AND G.GroupName ILIKE '%' || SerchText || '%')
			OR (SerchType = 8 AND U.LastName || ' ' || U.FirstName ILIKE '%' || SerchText || '%')
		  	))
	) T
	WHERE T.RowNum
	BETWEEN ((CurrentPageIndex - 1) * PageSize) + 1
	AND CurrentPageIndex * PageSize
	ORDER BY T.RowNum
	;

END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.