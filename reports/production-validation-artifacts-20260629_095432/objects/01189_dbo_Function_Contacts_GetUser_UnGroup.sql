-- ─── FUNCTION: contacts_getuser_ungroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuser_ungroup(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getuser_ungroup(
    userno integer,
    viewcount integer,
    currentpageindex integer,
    initial character varying
) RETURNS TABLE(
    totalcnt text,
    rownum text,
    company text,
    depart text,
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
    callname text
)
AS $function$
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
			FROM ContactsUser U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			WHERE U.RegUserNo = contacts_getuser_ungroup.userno 
			AND U.UseYn = 'Y'
			AND (M.GroupNo is Null OR M.UseYn='F')
			AND PATINDEX(public."UF_RegularExText"(Initial) + '%' , U.LastName+U.FirstName) > 0
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
			FROM ContactsUser U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			WHERE U.RegUserNo = contacts_getuser_ungroup.userno 
			AND U.UseYn = 'Y'
			AND (M.GroupNo is Null OR M.UseYn='F')
			AND PATINDEX(public."UF_RegularExText"(Initial) + '%' , U.LastName+U.FirstName) > 0
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
