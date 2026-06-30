-- ─── FUNCTION: contacts_findnonameuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_findnonameuser(integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_findnonameuser(
    serchtype integer,
    serchtext character varying,
    viewcount integer,
    currentpageindex integer
) RETURNS TABLE(
    seq serial,
    reguserno integer,
    userseq integer,
    type smallint,
    typename character varying(50),
    value character varying(500),
    isdefault character(1),
    regdate timestamp without time zone,
    moddate timestamp without time zone
)
AS $function$
BEGIN

	-- 전화번호검색
	IF SerchType = 1
	BEGIN
	IF Initial = 'ETC'
		BEGIN
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
		END
		ELSE
		BEGIN
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
		END
	END
	-- 회사 검색
	ELSE IF SerchType = 2
	BEGIN
	IF Initial = 'ETC'
		BEGIN
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
		END
		ELSE
		BEGIN
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
		END
	END
	-- 부서검색
	ELSE IF SerchType = 3
	BEGIN
	IF Initial = 'ETC'
		BEGIN
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
		END
		ELSE
		BEGIN
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
		END
	END
	--직위검색
	ELSE IF SerchType = 4
	BEGIN
	IF Initial = 'ETC'
		BEGIN
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
		END
		ELSE
		BEGIN
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
		END
	END
	-- 이메일
	ELSE IF SerchType = 5
	BEGIN
	IF Initial = 'ETC'
		BEGIN
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
		END
		ELSE
		BEGIN
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
		END
	END
	-- 그룹
	ELSE IF SerchType = 6
	BEGIN
	IF Initial = 'ETC'
		BEGIN
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
		END
		ELSE
		BEGIN
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
		END
	END
	-- 주소 검색
	ELSE IF SerchType = 7
	BEGIN
	IF Initial = 'ETC'
		BEGIN
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
		END
		ELSE
		BEGIN
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
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
