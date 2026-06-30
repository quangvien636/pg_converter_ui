-- ─── PROCEDURE→FUNCTION: contacts_getuser_togroupmobile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getuser_togroupmobile(integer, integer, integer, character varying, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getuser_togroupmobile(
    IN groupno integer,
    IN viewcount integer,
    IN currentpageindex integer,
    IN initial character varying,
    IN sortcolumn character varying,
    IN userno integer DEFAULT 10,
    IN isdefault character varying DEFAULT '1'
) RETURNS SETOF record
AS $function$
DECLARE
    topgroupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	--전체그룹인지 체크 합니다.

	SELECT GroupNo INTO topgroupno FROM ContactsGroup WHERE ParentGNo=0 and RegUserNo=contacts_getuser_togroupmobile.userno AND IsDefault='1'

	-- 전체 그룹이라면
	IF TopGroupNo = contacts_getuser_togroupmobile.groupno OR GroupNo=0 OR GroupNo=-1 THEN
		IF TextSearch='' THEN
			RETURN QUERY
			SELECT  T.Seq as seq,T.FirstName firstName,T.LastName lastName,T.email as email,T.Photo photo FROM (
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
			,E.Value as email

			FROM ContactsUser U
			--LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo

			left JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			LEFT JOIN ContactsEmail E ON E.UserSeq = U.Seq
			left JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo,M.IsDefault
					FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getuser_togroupmobile.userno and M.IsDefault = FALSE) as gg ON gg.UserSeq = U.Seq
			WHERE
			(U.RegUserNo = contacts_getuser_togroupmobile.userno  Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo = C.DepartNo))))
			AND
			 U.UseYn = 'Y'
			AND PATINDEX( '%' || public."UF_RegularExText"(Initial) + '%' , U.LastName+U.FirstName) > 0
			--AND gg.IsDefault=sDefault

			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount;

		ELSE
			 RETURN QUERY
			 SELECT  T.Seq as seq,T.FirstName firstName,T.LastName lastName,T.email as email,T.Photo photo FROM (
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
				,E.Value as email

				FROM ContactsUser U
				--LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo

				left JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
				LEFT JOIN ContactsEmail E ON E.UserSeq = U.Seq
				left JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo,M.IsDefault
						FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
						where M.RegUserNo=contacts_getuser_togroupmobile.userno and M.IsDefault = FALSE) as gg ON gg.UserSeq = U.Seq
				WHERE
				(U.RegUserNo = contacts_getuser_togroupmobile.userno  Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo = C.DepartNo))))
				AND
				 U.UseYn = 'Y'
				AND PATINDEX( '%' || public."UF_RegularExText"(Initial) + '%' , U.LastName+U.FirstName) > 0
				--AND gg.IsDefault=sDefault

				) T
				WHERE ((T.FirstName ILIKE '%' || TextSearch || '%') OR (T.LastName ILIKE '%' || TextSearch || '%')) AND T.RowNum
				BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
				AND CurrentPageIndex * ViewCount;
		 END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.