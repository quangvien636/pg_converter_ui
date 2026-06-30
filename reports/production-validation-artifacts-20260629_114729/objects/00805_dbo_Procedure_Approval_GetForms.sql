-- ─── PROCEDURE→FUNCTION: approval_getforms ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
DROP FUNCTION IF EXISTS public.approval_getforms(integer, integer, character varying, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_getforms(
    IN categoryno integer,
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
		rownum		int,
		formno		int
	);
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	 * 쿼리 조합 시작
	 */
	 

	Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	IF (SortColumn = 1) SET Query += 'FormNo ' THEN
	--ELSE IF (SortColumn = 2) SET Query += 'To '


	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC ' THEN
	ELSE SET Query += 'DESC '


	/*
	 * WHERE 조합 시작
	 */
	
	IF CategoryNo <> -1 THEN
	
		SET Query += ') RowNum, FormNo FROM Approval_Forms WHERE CategoryNo = CategoryNo '
		
	END IF;
	
	ELSE BEGIN
	
		SET Query += ') RowNum, FormNo FROM Approval_Forms WHERE 1 = 1 '
	
	END;
	

	INSERT INTO SearchResult
	EXECUTE format(Query, CategoryNo, SearchText);
	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1 THEN
	IF (TotalPageCount = 0) SET TotalPageCount = 1 THEN
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount THEN

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := approval_getforms.currentpageindex * CountPerPage;
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
