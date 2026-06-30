-- ─── FUNCTION: approval_getforms ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getforms(integer, integer, character varying, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_getforms(
    categoryno integer,
    searchtype integer,
    searchtext character varying,
    sortcolumn integer,
    isascending boolean,
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    formno text,
    name text,
    categoryno text,
    filetype text,
    description text
)
AS $function$
DECLARE
    query character varying;
    searchresult table (
		rownum		int,
		formno		int
	);
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
BEGIN


	/*
	 * 쿼리 조합 시작
	 */
	 

	SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '

	IF (SortColumn = 1) SET Query += 'FormNo '
	--ELSE IF (SortColumn = 2) SET Query += 'To '


	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC '
	ELSE SET Query += 'DESC '


	/*
	 * WHERE 조합 시작
	 */
	
	IF (CategoryNo <> -1) BEGIN
	
		SET Query += ') RowNum, FormNo FROM Approval_Forms WHERE CategoryNo = CategoryNo '
		
	END
	
	ELSE BEGIN
	
		SET Query += ') RowNum, FormNo FROM Approval_Forms WHERE 1 = 1 '
	
	END
	

	INSERT INTO SearchResult
	EXEC SP_EXECUTESQL Query,
		'CategoryNo AS INT, SearchText AS NVARCHAR(100)',
		CategoryNo, SearchText





	SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	SET TotalPageCount = TotalItemCount / CountPerPage
	
	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = approval_getforms.currentpageindex * CountPerPage
	
	RETURN QUERY
	SELECT F.FormNo, F.Name, F.CategoryNo, F.FileType, F.Description
	FROM SearchResult T
	INNER JOIN Approval_Forms F ON F.FormNo = T.FormNo
	WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum
	ORDER BY T.RowNum ASC

	RETURN QUERY
	SELECT TotalItemCount AS TotalMailCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
