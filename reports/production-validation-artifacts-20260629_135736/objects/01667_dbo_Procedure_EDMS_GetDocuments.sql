-- ─── PROCEDURE→FUNCTION: edms_getdocuments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
DROP FUNCTION IF EXISTS public.edms_getdocuments(integer, integer, integer, integer, integer, integer, character varying, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.edms_getdocuments(
    IN userno integer,
    IN boxtype integer,
    IN categoryno integer,
    IN quickpubliclevel integer,
    IN quicksecuritylevel integer,
    IN searchtype integer,
    IN searchtext character varying,
    IN sortcolumn integer,
    IN isascending boolean,
    IN countperpage integer,
    IN currentpageindex integer
) RETURNS SETOF record
AS $function$
DECLARE
    query character varying;
    searchresult table (
		rownum			bigint,
		documentno		bigint
	);
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	/*
	 * 권한 정보 정리
	 */
	
	Query := '' +;
		'INSERT INTO BelongToDepartments ' +
		'SELECT DepartNo, PositionNo ' +
		'FROM Organization_BelongToDepartment ' +
		'WHERE UserNo = UserNo ' +
		
		'' +

		'INSERT INTO ReadDocuments ' +
		'SELECT DISTINCT DocumentNo ' +
		'FROM EDMS_DocumentPermissions ' +
		'WHERE UserNo = UserNo OR DepartNo IN (SELECT DepartNo FROM BelongToDepartments) ' +
			'OR PositionNo IN (SELECT PositionNo FROM BelongToDepartments) ' 



	/*
	 * 쿼리 조합 시작
	 */
	 
	SET Query += 'SELECT ROW_NUMBER() OVER (ORDER BY '
	
	
	
	/*
	 * 정렬 컬럼
	 */
		 
	IF (SortColumn = 1) SET Query += 'D.DocumentNo ' THEN
	ELSIF (SortColumn = 2) SET Query += 'D.SerialNumber ' THEN
	ELSIF (SortColumn = 3) SET Query += 'D.Title ' THEN
	ELSIF (SortColumn = 4) SET Query += 'D.Version ' THEN
	ELSIF (SortColumn = 5) SET Query += 'D.PublicLevel ' THEN
	ELSIF (SortColumn = 6) SET Query += 'D.SecurityLevel ' THEN
	ELSIF (SortColumn = 7) SET Query += 'D.RegDepartName ' THEN
	ELSIF (SortColumn = 8) SET Query += 'D.RegUserName ' THEN
	ELSIF (SortColumn = 9) SET Query += 'D.RegDate ' THEN



	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC ' THEN
	ELSE SET Query += 'DESC '


	SET Query += ') RowNum, D.DocumentNo '
	
	
	
	/*
	 * 테이블 연결
	 */
	 
	IF BoxType = 1 THEN
	
		SET Query +=
			'FROM EDMS_Documents D ' +
			'WHERE D.IsDelete = FALSE ' +
				'AND (D.PublicLevel = 1 OR (D.PublicLevel = 2 AND (D.DocumentNo IN (SELECT DocumentNo FROM ReadDocuments) OR D.RegUserNo = UserNo OR D.ModUserNo = UserNo))) '
	
	END IF;
	
	ELSIF BoxType = 2 THEN
	
		SET Query +=
			'FROM EDMS_Documents D ' +
			'WHERE D.IsDelete = TRUE '
			
	END IF;
	
	ELSIF BoxType = 3 THEN
	
		SET Query +=
			'FROM EDMS_Documents D ' +
			'WHERE D.IsDelete = TRUE '
			
	END IF;

	ELSIF BoxType = 4 THEN
	
		SET Query +=
			'FROM EDMS_Documents D ' +
			'WHERE D.IsDelete = FALSE AND D.CategoryNo = CategoryNo ' +
				'AND (D.PublicLevel = 1 OR (D.PublicLevel = 2 AND (D.DocumentNo IN (SELECT DocumentNo FROM ReadDocuments) OR D.RegUserNo = UserNo OR D.ModUserNo = UserNo))) '
	
	END IF;
	
		
	
	/*
	 * 빠른 검색 
	 */

	IF QuickPublicLevel != 0 THEN
	
		SET Query += 'AND D.PublicLevel = PublicLevel '
	
	END IF;
	
	IF QuickSecurityLevel != 0 THEN
	
		SET Query += 'AND D.SecurityLevel = SecurityLevel '
	
	END IF;
	
	
	
	/*
	 * 검색 조건
	 */
	 
	IF SearchText != '' THEN

		IF (SearchType = 1) SET Query += 'AND D.DocumentNo = SearchText ' THEN
		ELSIF (SearchType = 2) SET Query += 'AND D.SerialNumber ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 3) SET Query += 'AND D.Title ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 4) SET Query += 'AND D.Version ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 5) SET Query += 'AND D.RegDepartName ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 6) SET Query += 'AND D.RegUserName ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 7) SET Query += 'AND D.RegDate ILIKE ''%'' || SearchText || ''%'' ' THEN

	END IF;
		
	
	
	/*
	 * 최종본
	 */
	 

	INSERT INTO SearchResult
	EXECUTE format(Query, UserNo, CategoryNo, QuickPublicLevel, QuickSecurityLevel, SearchText);
	/*
	 * 마지막 정리
	 */





	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1 THEN
	IF (TotalPageCount = 0) SET TotalPageCount = 1 THEN
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount THEN

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := edms_getdocuments.currentpageindex * CountPerPage;
	IF BoxType != 4 THEN

		RETURN QUERY
		SELECT D.DocumentNo, D.RegUserNo, D.RegDate, D.RegUserName, D.RegDepartName, D.Title, D.CategoryNo, D.PublicLevel, D.SecurityLevel, D.Version, D.SerialNumber,
			C.Name AS CategoryName, P.Name AS PublicLevelName, S.Name AS SecurityLevelName
		FROM SearchResult T
		INNER JOIN EDMS_Documents D ON D.DocumentNo = T.DocumentNo
		INNER JOIN EDMS_Categories C ON C.CategoryNo = D.CategoryNo
		INNER JOIN EDMS_PublicLevels P ON P.LevelNo = D.PublicLevel
		INNER JOIN EDMS_SecurityLevels S ON S.LevelNo = D.SecurityLevel
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum
		ORDER BY T.RowNum ASC
	
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT D.DocumentNo, D.RegUserNo, D.RegDate, D.RegUserName, D.RegDepartName, D.Title, D.CategoryNo, D.PublicLevel, D.SecurityLevel, D.Version, D.SerialNumber,
			'' AS CategoryName, P.Name AS PublicLevelName, S.Name AS SecurityLevelName
		FROM SearchResult T
		INNER JOIN EDMS_Documents D ON D.DocumentNo = T.DocumentNo
		INNER JOIN EDMS_PublicLevels P ON P.LevelNo = D.PublicLevel
		INNER JOIN EDMS_SecurityLevels S ON S.LevelNo = D.SecurityLevel
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum
		ORDER BY T.RowNum ASC
	
	END;
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalDocumentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
