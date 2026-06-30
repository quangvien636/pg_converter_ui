-- ─── PROCEDURE→FUNCTION: contacts_findnonameuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_findnonameuser(integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_findnonameuser(
    IN serchtype integer,
    IN serchtext character varying,
    IN viewcount integer,
    IN currentpageindex integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- 전화번호검색
	IF SerchType = 1 THEN
	IF Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
			WHERE 
			N.Value ILIKE '%' || SerchText || '%'
			AND (U.FirstName+U.LastName) = ''
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
			GROUP BY U.Seq
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
				,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
				WHERE 
				PATINDEX(public."UF_RegularExText"(Initial) + '%' , U.LastName) > 0
				AND N.Value ILIKE '%' || SerchText || '%'
				AND (U.FirstName+U.LastName) = ''
				GROUP BY U.Seq
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
	-- 회사 검색
	ELSIF SerchType = 2 THEN
	IF Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
			WHERE 
			C.Company ILIKE '%' || SerchText || '%'
			AND (U.FirstName+U.LastName) = ''
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
			GROUP BY U.Seq
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
				,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
				WHERE 
				PATINDEX(public."UF_RegularExText"(Initial) + '%' , U.LastName) > 0
				AND C.Company ILIKE '%' || SerchText || '%'
				AND (U.FirstName+U.LastName) = ''
				GROUP BY U.Seq
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
	-- 부서검색
	ELSIF SerchType = 3 THEN
	IF Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
			WHERE 
			C.Depart ILIKE '%' || SerchText || '%'
			AND (U.FirstName+U.LastName) = ''
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
			GROUP BY U.Seq
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
				,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
				WHERE 
				PATINDEX(public."UF_RegularExText"(Initial) + '%' , U.LastName) > 0
				AND C.Depart ILIKE '%' || SerchText || '%'
				AND (U.FirstName+U.LastName) = ''
				GROUP BY U.Seq
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
	--직위검색
	ELSIF SerchType = 4 THEN
	IF Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
			WHERE 
			C.Position ILIKE '%' || SerchText || '%'
			AND (U.FirstName+U.LastName) = ''
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
			GROUP BY U.Seq
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
				,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
				WHERE 
				PATINDEX(public."UF_RegularExText"(Initial) + '%' , U.LastName) > 0
				AND C.Position ILIKE '%' || SerchText || '%'
				AND (U.FirstName+U.LastName) = ''
				GROUP BY U.Seq
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
	-- 이메일
	ELSIF SerchType = 5 THEN
	IF Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
			WHERE 
			E.Value ILIKE '%' || SerchText || '%'
			AND (U.FirstName+U.LastName) = ''
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
			GROUP BY U.Seq
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
				,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
				WHERE 
				PATINDEX(public."UF_RegularExText"(Initial) + '%' , U.LastName) > 0
				AND E.Value ILIKE '%' || SerchText || '%'
				AND (U.FirstName+U.LastName) = ''
				GROUP BY U.Seq
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
	-- 그룹
	ELSIF SerchType = 6 THEN
	IF Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
			WHERE 
			(SELECT GroupName FROM ContactsGroup WHERE G.GroupNo=GroupNo) ILIKE '%' || SerchText || '%'
			AND (U.FirstName+U.LastName) = ''
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
			GROUP BY U.Seq
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
				,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
				WHERE 
				PATINDEX(public."UF_RegularExText"(Initial) + '%' , U.LastName) > 0
				AND (U.FirstName+U.LastName) = ''
				AND (SELECT GroupName FROM ContactsGroup WHERE G.GroupNo=GroupNo) ILIKE '%' || SerchText || '%'
				GROUP BY U.Seq
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
	-- 주소 검색
	ELSIF SerchType = 7 THEN
	IF Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
			FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
			LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
			WHERE 
			A.Address ILIKE '%' || SerchText || '%'
			AND (U.FirstName+U.LastName) = ''
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
			GROUP BY U.Seq
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
				,CONVERT(INT, ROW_NUMBER() OVER (ORDER BY U.LastName ASC)) AS RowNum
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
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=UserNo AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				LEFT JOIN (SELECT * FROM ContactsAddress WHERE RegUserNo=UserNo) A ON A.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsCompany WHERE RegUserNo=UserNo) C ON C.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsDays WHERE RegUserNo=UserNo) D ON D.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsEmail WHERE RegUserNo=UserNo) E ON E.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsHomepage WHERE RegUserNo=UserNo) H ON H.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsNumber WHERE RegUserNo=UserNo) N ON N.UserSeq=U.Seq
				LEFT JOIN (SELECT * FROM ContactsSns WHERE RegUserNo=UserNo) S ON S.UserSeq=U.Seq 
				WHERE 
				PATINDEX(public."UF_RegularExText"(Initial) + '%' , U.LastName) > 0
				AND (U.FirstName+U.LastName) = ''
				AND A.Address ILIKE '%' || SerchText || '%'
				GROUP BY U.Seq
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
