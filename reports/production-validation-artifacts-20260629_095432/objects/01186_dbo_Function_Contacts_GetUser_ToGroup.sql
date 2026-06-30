-- ─── FUNCTION: contacts_getuser_togroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuser_togroup(integer, integer, integer, integer, character varying, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getuser_togroup(
    userno integer DEFAULT 10,
    groupno integer DEFAULT 0,
    viewcount integer DEFAULT 10,
    currentpageindex integer DEFAULT 1,
    initial character varying DEFAULT '',
    isdefault character varying DEFAULT '1',
    serchtype integer DEFAULT 0,
    serchtext character varying DEFAULT ''
) RETURNS TABLE(
    groupno serial,
    groupname text,
    reguserno integer,
    regdate timestamp without time zone,
    memo character varying(500),
    parentgno integer,
    sort integer,
    isdefault character(1),
    useyn character(1)
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    topgroupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	--전체그룹인지 체크 합니다.

	SELECT TopGroupNo=contacts_getuser_togroup.groupno FROM ContactsGroup WHERE ParentGNo=0 and RegUserNo=contacts_getuser_togroup.userno AND IsDefault='1'
	
	-- 전체 그룹이라면
	IF (TopGroupNo = contacts_getuser_togroup.groupno OR GroupNo=0 OR GroupNo=-1)
	BEGIN
		IF Initial = 'ETC'
		BEGIN
			RETURN QUERY
			SELECT DISTINCT Seq, * FROM (SELECT 
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY 
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
			,gg.IsDefault
			FROM ContactsUser U
			--LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			LEFT JOIN (SELECT /* TOP 1 */  G.UserSeq,M.IsDefault FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo) as gg ON gg.UserSeq = U.Seq
			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault='1'
			WHERE (U.RegUserNo = contacts_getuser_togroup.userno  Or U.Share=300)
			AND U.UseYn = 'Y'
			AND PATINDEX(public."UF_RegularExText"('ㄱ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') + '%' , U.LastName+U.FirstName) = 0
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount
		END
		ELSE
		BEGIN

		IF GroupNo=0 BEGIN
		
		RETURN QUERY
		SELECT DISTINCT Seq, * FROM (
			SELECT 
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY 
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			)) AS RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
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
			,gg.IsDefault
			FROM ContactsUser U
			
			
			--inner join (select distinct  gg.GroupNo,gg.UserSeq from ContactsGroupUser gg where  gg.GroupNo=GroupNo ) as G on G.UserSeq = U.Seq
			--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			LEFT JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo,M.GroupNo,M.IsDefault
					FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getuser_togroup.userno and M.IsDefault='0') as gg ON gg.UserSeq = U.Seq
			WHERE (U.RegUserNo = contacts_getuser_togroup.userno  Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select Distinct C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo = C.DepartNo))))
			AND U.UseYn = 'Y'
						
			AND PATINDEX('%' || public."UF_RegularExText"(Initial) + '%' , U.LastName+U.FirstName) > 0
			
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount
			

			END
		ELSE IF GroupNo=-1 BEGIN
				
		RETURN QUERY
		SELECT  * FROM (
			SELECT 
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY 
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			)) AS RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
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
			,gg.IsDefault

			FROM ContactsUser U
			--LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			
			left JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			left JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo,M.IsDefault
					FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getuser_togroup.userno and M.IsDefault = FALSE) as gg ON gg.UserSeq = U.Seq
			WHERE 
			(U.RegUserNo = contacts_getuser_togroup.userno  Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo = C.DepartNo))))
			AND
			 U.UseYn = 'Y'						
			AND PATINDEX( '%' || public."UF_RegularExText"(Initial) + '%' , U.LastName+U.FirstName) > 0
			--AND gg.IsDefault=IsDefault

			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount
			


			END

		ELSE BEGIN
			if(IsDefault='1') BEGIN 

			RETURN QUERY
			SELECT  *	 FROM (
				SELECT 
				CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
				,CONVERT(INT, ROW_NUMBER() OVER (
				ORDER BY 
					CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
					CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
					CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
					CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
					CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
					CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
				)) AS RowNum
				,COALESCE(C.Company,'') as Company
				,COALESCE(C.Depart,'') as Depart
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
				,1 as IsDefault
				FROM ContactsUser U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			
				left JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
				--nghiem remove 2018-11-12
				--inner JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo 
				--	FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
				--	where M.RegUserNo=UserNo and M.IsDefault=IsDefault) as gg ON gg.UserSeq = U.Seq
				--WHERE (U.RegUserNo = UserNo  Or U.Share='300' OR ((SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo = C.DepartNo)))))--and gg.RegUserNo = UserNo))
				WHERE --(U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo = C.DepartNo))--and gg.RegUserNo = UserNo)
				  U.UseYn = 'Y'
				AND	G.GroupNo in (select * from Contacts_GetChildGroupByGroupNo(GroupNo))		
				AND PATINDEX('%' || public."UF_RegularExText"(Initial) + '%' , U.LastName+U.FirstName) > 0
				--AND gg.IsDefault=IsDefault
				) T
				WHERE T.RowNum
				BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
				AND CurrentPageIndex * ViewCount
			end 
			ELSE BEGIN

			RETURN QUERY
			SELECT  * FROM (
			SELECT 
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY 
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			)) AS RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
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
			,M.IsDefault
			FROM ContactsUser U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			--LEFT JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo,M.GroupNo,M.IsDefault
			--		FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			--		where M.RegUserNo=UserNo ) as gg ON gg.UserSeq = U.Seq

			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			--LEFT JOIN (SELECT /* TOP 1 */  G.UserSeq FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo) as gg ON gg.UserSeq = U.Seq
			WHERE (U.RegUserNo = contacts_getuser_togroup.userno  Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' AND G.GroupNo=contacts_getuser_togroup.groupno) OR (SUBSTRING(U.Share,1,3)='200' and U.RegUserNo = contacts_getuser_togroup.userno))
			AND U.UseYn = 'Y'
			AND	G.GroupNo in (select * from Contacts_GetChildGroupByGroupNo(GroupNo))
			
			AND PATINDEX('%' || public."UF_RegularExText"(Initial) + '%' , U.LastName+U.FirstName) > 0
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount
			
			END
		END

		END
	END
	ELSE
	BEGIN
		IF Initial = 'ETC'
		BEGIN
			RETURN QUERY
			SELECT * FROM (SELECT 
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY 
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
			,M.IsDefault
			FROM ContactsUser U
			INNER JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			--LEFT JOIN (SELECT /* TOP 1 */  G.UserSeq FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo) as gg ON gg.UserSeq = U.Seq
			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			WHERE (U.RegUserNo = contacts_getuser_togroup.userno  Or U.Share=300) AND G.GroupNo = contacts_getuser_togroup.groupno 
			AND U.UseYn = 'Y'
			AND M.UseYn='Y'
			AND PATINDEX(public."UF_RegularExText"('ㄱ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') + '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') + '%' , U.LastName+U.FirstName) = 0
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount
		END
		ELSE
		BEGIN
			RETURN QUERY
			SELECT * FROM (SELECT 
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt,
			CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY 
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
			,0 as IsDefault
			FROM ContactsUser U
			--INNER JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			--INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			LEFT JOIN (SELECT distinct M.GroupNo, G.UserSeq FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo where M.UseYn='Y') as gg ON gg.UserSeq = U.Seq
			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			WHERE (U.RegUserNo = contacts_getuser_togroup.userno  Or U.Share='300' OR SUBSTRING(U.Share,1,3)='200') 
			AND	gg.GroupNo in (select * from Contacts_GetChildGroupByGroupNo(GroupNo))
			AND U.UseYn = 'Y'
			--AND M.UseYn='Y'
			AND PATINDEX( '%' || public."UF_RegularExText"(Initial) + '%' , U.LastName+U.FirstName) > 0
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
