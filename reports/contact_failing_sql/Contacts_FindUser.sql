-- ─── PROCEDURE→FUNCTION: contacts_finduser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_finduser(integer, integer, character varying, integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_finduser(
    IN userno integer,
    IN serchtype integer,
    IN serchtext character varying,
    IN viewcount integer,
    IN currentpageindex integer,
    IN initial character varying,
    IN sortcolumn character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- 이름검색
	IF SerchType = 0 THEN
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
			WHERE
			(U.FirstName + U.LastName) ILIKE '%' || SerchText || '%'
			AND PATINDEX(public."UF_RegularExText"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') || '%' , U.LastName) = 0
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
			AND CurrentPageIndex * ViewCount;
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
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
			WHERE
			PATINDEX(public."UF_RegularExText"(Initial) || '%' , U.LastName) > 0
			AND (((U.FirstName + U.LastName) ILIKE '%' || SerchText || '%') OR ((U.LastName + U.FirstName) ILIKE '%' || SerchText || '%'))
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
			AND CurrentPageIndex * ViewCount;
		END IF;
	-- 전화번호검색
	ELSIF SerchType = 1 THEN
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
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
			WHERE
			N.Value ILIKE '%' || SerchText || '%'
			AND PATINDEX(public."UF_RegularExText"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') || '%' , U.LastName) = 0
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
			AND CurrentPageIndex * ViewCount;
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
					CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."UF_RegularExText"(Initial) || '%' , U.LastName) > 0
				AND N.Value ILIKE '%' || SerchText || '%'
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
			AND CurrentPageIndex * ViewCount;
		END IF;
	END IF;
	-- 회사 검색
	ELSIF SerchType = 2 THEN
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
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
			WHERE
			C.Company ILIKE '%' || SerchText || '%'
			AND PATINDEX(public."UF_RegularExText"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') || '%' , U.LastName) = 0
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
			AND CurrentPageIndex * ViewCount;
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
					CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."UF_RegularExText"(Initial) || '%' , U.LastName) > 0
				AND C.Company ILIKE '%' || SerchText || '%'
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
			AND CurrentPageIndex * ViewCount;
		END IF;

	-- 부서검색
	ELSIF SerchType = 3 THEN
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
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
			WHERE
			C.Depart ILIKE '%' || SerchText || '%'
			AND PATINDEX(public."UF_RegularExText"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') || '%' , U.LastName) = 0
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
			AND CurrentPageIndex * ViewCount;
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
					CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."UF_RegularExText"(Initial) || '%' , U.LastName) > 0
				AND C.Depart ILIKE '%' || SerchText || '%'
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
			AND CurrentPageIndex * ViewCount;
		END IF;

	--직위검색
	ELSIF SerchType = 4 THEN
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
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
			WHERE
			C.Position ILIKE '%' || SerchText || '%'
			AND PATINDEX(public."UF_RegularExText"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') || '%' , U.LastName) = 0
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
			AND CurrentPageIndex * ViewCount;
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
					CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."UF_RegularExText"(Initial) || '%' , U.LastName) > 0
				AND C.Position ILIKE '%' || SerchText || '%'
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
			AND CurrentPageIndex * ViewCount;
		END IF;

	-- 이메일
	ELSIF SerchType = 5 THEN
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
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
			WHERE
			E.Value ILIKE '%' || SerchText || '%'
			AND PATINDEX(public."UF_RegularExText"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') || '%' , U.LastName) = 0
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
			AND CurrentPageIndex * ViewCount;
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
					CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."UF_RegularExText"(Initial) || '%' , U.LastName) > 0
				AND E.Value ILIKE '%' || SerchText || '%'
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
			AND CurrentPageIndex * ViewCount;
		END IF;

	-- 그룹
	ELSIF SerchType = 6 THEN
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
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
			WHERE
			(SELECT GroupName FROM ContactsGroup WHERE G.GroupNo=GroupNo) ILIKE '%' || SerchText || '%'
			AND PATINDEX(public."UF_RegularExText"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') || '%' , U.LastName) = 0
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
			AND CurrentPageIndex * ViewCount;
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
					CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."UF_RegularExText"(Initial) || '%' , U.LastName) > 0
				AND (SELECT GroupName FROM ContactsGroup WHERE G.GroupNo=GroupNo) ILIKE '%' || SerchText || '%'
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
			AND CurrentPageIndex * ViewCount;
		END IF;

	-- 주소 검색
	ELSIF SerchType = 7 THEN
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
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
			WHERE
			A.Address ILIKE '%' || SerchText || '%'
			AND PATINDEX(public."UF_RegularExText"('ㄱ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') || '%' , U.LastName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') || '%' , U.LastName) = 0
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
			AND CurrentPageIndex * ViewCount;
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
					CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_finduser.userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=contacts_finduser.userno) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=contacts_finduser.userno) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=contacts_finduser.userno) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=contacts_finduser.userno) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=contacts_finduser.userno) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=contacts_finduser.userno) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=contacts_finduser.userno) S ON S.UserSeq=U.Seq
				WHERE
				PATINDEX(public."UF_RegularExText"(Initial) || '%' , U.LastName) > 0
				AND A.Address ILIKE '%' || SerchText || '%'
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
			AND CurrentPageIndex * ViewCount;
		END IF;

	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.