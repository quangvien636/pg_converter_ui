-- ─── FUNCTION: edms_getdocuments ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getdocuments(integer, integer, integer, integer, integer, integer, character varying, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.edms_getdocuments(
    userno integer,
    boxtype integer,
    categoryno integer,
    quickpubliclevel integer,
    quicksecuritylevel integer,
    searchtype integer,
    searchtext character varying,
    sortcolumn integer,
    isascending boolean,
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    documentno text,
    reguserno text,
    regdate text,
    regusername text,
    regdepartname text,
    title text,
    categoryno text,
    publiclevel text,
    securitylevel text,
    version text,
    serialnumber text,
    categoryname text,
    publiclevelname text,
    securitylevelname text
)
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
BEGIN



	/*
	 * 권한 정보 정리
	 */
	
	SET Query =
		'DECLARE BelongToDepartments TABLE (' +
			'DepartNo	INT, ' +
			'PositionNo	INT ' +
		') ' +

		'INSERT INTO BelongToDepartments ' +
		'SELECT DepartNo, PositionNo ' +
		'FROM Organization_BelongToDepartment ' +
		'WHERE UserNo = UserNo ' +
		
		'DECLARE ReadDocuments TABLE ( ' +
			'DocumentNo	BIGINT ' +
		') ' +

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
		 
	IF (SortColumn = 1) SET Query += 'D.DocumentNo '
	ELSE IF (SortColumn = 2) SET Query += 'D.SerialNumber '
	ELSE IF (SortColumn = 3) SET Query += 'D.Title '
	ELSE IF (SortColumn = 4) SET Query += 'D.Version '
	ELSE IF (SortColumn = 5) SET Query += 'D.PublicLevel '
	ELSE IF (SortColumn = 6) SET Query += 'D.SecurityLevel '
	ELSE IF (SortColumn = 7) SET Query += 'D.RegDepartName '
	ELSE IF (SortColumn = 8) SET Query += 'D.RegUserName '
	ELSE IF (SortColumn = 9) SET Query += 'D.RegDate '



	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC '
	ELSE SET Query += 'DESC '


	SET Query += ') RowNum, D.DocumentNo '
	
	
	
	/*
	 * 테이블 연결
	 */
	 
	IF (BoxType = 1) BEGIN
	
		SET Query +=
			'FROM EDMS_Documents D ' +
			'WHERE D.IsDelete = FALSE ' +
				'AND (D.PublicLevel = 1 OR (D.PublicLevel = 2 AND (D.DocumentNo IN (SELECT DocumentNo FROM ReadDocuments) OR D.RegUserNo = UserNo OR D.ModUserNo = UserNo))) '
	
	END
	
	ELSE IF (BoxType = 2) BEGIN
	
		SET Query +=
			'FROM EDMS_Documents D ' +
			'WHERE D.IsDelete = TRUE '
			
	END
	
	ELSE IF (BoxType = 3) BEGIN
	
		SET Query +=
			'FROM EDMS_Documents D ' +
			'WHERE D.IsDelete = TRUE '
			
	END

	ELSE IF (BoxType = 4) BEGIN
	
		SET Query +=
			'FROM EDMS_Documents D ' +
			'WHERE D.IsDelete = FALSE AND D.CategoryNo = CategoryNo ' +
				'AND (D.PublicLevel = 1 OR (D.PublicLevel = 2 AND (D.DocumentNo IN (SELECT DocumentNo FROM ReadDocuments) OR D.RegUserNo = UserNo OR D.ModUserNo = UserNo))) '
	
	END
	
		
	
	/*
	 * 빠른 검색 
	 */

	IF (QuickPublicLevel != 0) BEGIN
	
		SET Query += 'AND D.PublicLevel = PublicLevel '
	
	END
	
	IF (QuickSecurityLevel != 0) BEGIN
	
		SET Query += 'AND D.SecurityLevel = SecurityLevel '
	
	END
	
	
	
	/*
	 * 검색 조건
	 */
	 
	IF (SearchText != '') BEGIN

		IF (SearchType = 1) SET Query += 'AND D.DocumentNo = SearchText '
		ELSE IF (SearchType = 2) SET Query += 'AND D.SerialNumber ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 3) SET Query += 'AND D.Title ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 4) SET Query += 'AND D.Version ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 5) SET Query += 'AND D.RegDepartName ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 6) SET Query += 'AND D.RegUserName ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 7) SET Query += 'AND D.RegDate ILIKE ''%'' || SearchText || ''%'' '

	END
		
	
	
	/*
	 * 최종본
	 */
	 

	INSERT INTO SearchResult
	EXEC SP_EXECUTESQL Query,
		'UserNo AS INT, CategoryNo AS INT, PublicLevel AS INT, SecurityLevel AS INT, SearchText AS NVARCHAR(100)',
		UserNo, CategoryNo, QuickPublicLevel, QuickSecurityLevel, SearchText
	
	
	
	/*
	 * 마지막 정리
	 */





	SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = edms_getdocuments.currentpageindex * CountPerPage
	
	IF (BoxType != 4) BEGIN

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
	
	END
	
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
	
	END
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalDocumentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
