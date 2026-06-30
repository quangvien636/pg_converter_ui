-- ─── PROCEDURE→FUNCTION: contacts_finall ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_finall(integer, integer, character varying, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_finall(
    IN userno integer,
    IN serchtype integer,
    IN serchtext character varying,
    IN viewcount integer,
    IN currentpageindex integer,
    IN initial character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF SerchType = 8 THEN
		IF Initial = 'ETC' THEN
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finall.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finall.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finall.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finall.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finall.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finall.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finall.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finall.userno) S ON S.UserSeq=U.Seq
			WHERE 
			((U.LastName || ' ' || U.FirstName) ILIKE '%' || SerchText || '%' or (U.FirstName || ' ' || U.LastName) ILIKE '%' || SerchText || '%'  or C.Company ILIKE '%' || SerchText || '%' or C.Depart ILIKE '%' || SerchText || '%' or C.Position ILIKE '%' || SerchText || '%' or E.Value ILIKE '%' || SerchText || '%' or (SELECT GroupName FROM ContactsGroup WHERE G.GroupNo=GroupNo) ILIKE '%' || SerchText || '%' or A.Address ILIKE '%' || SerchText || '%')
			AND PATINDEX(public."UF_RegularExText"('ㄱ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') + '%' , U.LastName) = 0
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
		END IF;
		ELSE
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finall.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finall.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finall.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finall.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finall.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finall.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finall.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finall.userno) S ON S.UserSeq=U.Seq
			WHERE 
			PATINDEX(public."UF_RegularExText"(Initial) + '%' , U.LastName) > 0
			AND ((U.LastName || ' ' || U.FirstName) ILIKE '%' || SerchText || '%' or (U.FirstName || ' ' || U.LastName) ILIKE '%' || SerchText || '%' or C.Company ILIKE '%' || SerchText || '%' or C.Depart ILIKE '%' || SerchText || '%' or C.Position ILIKE '%' || SerchText || '%' or E.Value ILIKE '%' || SerchText || '%' or (SELECT GroupName FROM ContactsGroup WHERE G.GroupNo=GroupNo) ILIKE '%' || SerchText || '%' or A.Address ILIKE '%' || SerchText || '%')
			GROUP BY C.Company
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
		END IF;
	END IF;
	ELSE
		IF SerchType = 9 THEN
		IF Initial = 'ETC' THEN
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finall.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finall.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finall.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finall.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finall.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finall.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finall.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finall.userno) S ON S.UserSeq=U.Seq
			WHERE 
			(TO_CHAR(U.RegDate, 'YYYY-MM-DD HH24:MI:SS') ILIKE '%' || SerchText || '%' or TO_CHAR(U.ModDate, 'YYYY-MM-DD HH24:MI:SS') ILIKE '%' || SerchText || '%' or TO_CHAR(U.CheckDate, 'YYYY-MM-DD HH24:MI:SS') ILIKE '%' || SerchText || '%')			
			AND PATINDEX(public."UF_RegularExText"('ㄱ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') + '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') + '%' , U.LastName) = 0
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
		END IF;
		ELSE
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finall.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finall.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finall.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finall.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finall.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finall.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finall.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finall.userno) S ON S.UserSeq=U.Seq
			WHERE 
			PATINDEX(public."UF_RegularExText"(Initial) + '%' , U.LastName) > 0
			AND
			(TO_CHAR(U.RegDate, 'YYYY-MM-DD HH24:MI:SS') ILIKE '%' || SerchText || '%' or TO_CHAR(U.ModDate, 'YYYY-MM-DD HH24:MI:SS') ILIKE '%' || SerchText || '%' or TO_CHAR(U.CheckDate, 'YYYY-MM-DD HH24:MI:SS') ILIKE '%' || SerchText || '%')						
			GROUP BY C.Company
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
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
