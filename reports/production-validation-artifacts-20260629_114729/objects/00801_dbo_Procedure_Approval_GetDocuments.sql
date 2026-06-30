-- ─── PROCEDURE→FUNCTION: approval_getdocuments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
DROP FUNCTION IF EXISTS public.approval_getdocuments(integer, integer, integer, character varying, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_getdocuments(
    IN userno integer,
    IN boxtype integer,
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
		documentno		bigint,
		approverno		bigint
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
	/*
	 * 정렬 컬럼
	 */
		 
	IF (SortColumn = 1) SET Query += 'D.DocumentNo ' THEN
	ELSIF (SortColumn = 2) SET Query += 'D.Title ' THEN
	ELSIF (SortColumn = 3) SET Query += 'D.ModDepartName ' THEN
	ELSIF (SortColumn = 4) SET Query += 'D.ModUserName ' THEN
	ELSIF (SortColumn = 5) SET Query += 'A2.UserName ' THEN
	ELSIF (SortColumn = 6) SET Query += 'D.RegDate ' THEN
	ELSIF (SortColumn = 7) SET Query += 'A.ArriveDate ' THEN
	ELSIF (SortColumn = 8) SET Query += 'A2.ArriveDate ' THEN
	ELSIF (SortColumn = 9) SET Query += 'A2.ApprovalDate ' THEN
	ELSIF (SortColumn = 10) SET Query += 'A.ApprovalDate ' THEN



	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC ' THEN
	ELSE SET Query += 'DESC '


	SET Query += ') RowNum, D.DocumentNo, '



	/*
	 * 문서 목록
	 */
	 
	IF (BoxType = 101) BEGIN  /* 결재함 - 결재 */ THEN

		SET Query +=
			'A.ApproverNo AS ApproverNo ' +
			
			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'WHERE D.State = 200 AND A.UserNo = UserNo AND A.ApprovalType = 200 AND A.ArriveState = 200 '

	END;

	ELSIF (BoxType = 103) BEGIN /* 결재함 - 합의 */ THEN

		SET Query +=
			'A.ApproverNo AS ApproverNo ' +
			
			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'WHERE D.State = 200 AND A.UserNo = UserNo AND A.ApprovalType = 300 AND A.ArriveState = 200 '
			
	END;

	ELSIF (BoxType = 105) BEGIN /* 결재함 - 수신 */ THEN

		SET Query +=
			'A.ApproverNo AS ApproverNo ' +
			
			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'WHERE D.State = 300 AND A.UserNo = UserNo AND A.ApprovalType = 600 AND A.ArriveState = 200 '
			
	END;

	ELSIF (BoxType = 107) BEGIN /* 결재함 - 보류 */ THEN

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +
			
			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 500 AND A.UserNo = UserNo AND A.ArriveState != 100 '
			
	END;

	ELSIF (BoxType = 108) BEGIN /* 결재함 - 진행 */ THEN

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 200 AND A.UserNo = UserNo AND A.ArriveState = 300 '
			
	END;

	ELSIF (BoxType = 201) BEGIN /* 기안함 - 진행 */ THEN

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 200 AND D.ModUserNo = UserNo '

	END;

	ELSIF (BoxType = 202) BEGIN /* 기안함 - 보류*/ THEN

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 500 AND D.ModUserNo = UserNo '

	END;

	ELSIF (BoxType = 203) BEGIN /* 기안함 - 반려 */ THEN

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 400 AND D.ModUserNo = UserNo '
			
	END;

	ELSIF (BoxType = 204) BEGIN /* 기안함 - 완료 */ THEN

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 300 AND D.ModUserNo = UserNo '
			
	END;

	ELSIF (BoxType = 301) BEGIN  /* 종결함 - 완료 */ THEN

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 300 AND A.UserNo = UserNo AND A.ArriveState = 300 AND A.ApprovalType IN (200, 300) '

	END;

	ELSIF (BoxType = 302) BEGIN /* 종결함 - 반려*/ THEN

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 400 AND A.UserNo = UserNo AND A.ArriveState = 300 '
			
	END;

	ELSIF (BoxType = 403) BEGIN /* 문서수발신함 - 완료 */ THEN

		SET Query +=
			'A.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'WHERE D.State = 300 AND A.UserNo = UserNo AND A.ApprovalType = 600 AND A.ArriveState = 300 '

	END;
	
	ELSIF (BoxType = 501) BEGIN /* 전사문서함 - 진행 */ THEN
	
		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 200 '
	END;
	
	ELSIF (BoxType = 502) BEGIN /* 전사문서함 - 보류 */ THEN
	
		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 500 '
	END;
	
	ELSIF (BoxType = 503) BEGIN /* 전사문서함 - 반려 */ THEN
	
		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 400 '
	END;

	ELSIF (BoxType = 504) BEGIN /* 전사문서함 - 완료 */ THEN
	
		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 300 '
	END;



	/*
	 * 검색 조건
	 */
	 
	IF SearchText != '' THEN

		IF (SearchType = 1) SET Query += 'AND D.DocumentNo = SearchText ' THEN
		ELSIF (SearchType = 2) SET Query += 'AND D.Title ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 3) SET Query += 'AND D.ModDepartName ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 4) SET Query += 'AND D.ModUserName ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 5) SET Query += 'AND A2.UserName ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 6) SET Query += 'AND D.RegDate ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 7) SET Query += 'AND A.ArriveDate ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 8) SET Query += 'AND A2.ArriveDate ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 9) SET Query += 'AND A2.ApprovalDate ILIKE ''%'' || SearchText || ''%'' ' THEN
		ELSIF (SearchType = 10) SET Query += 'AND A.ApprovalDate ILIKE ''%'' || SearchText || ''%'' ' THEN

	END IF;
	
	
	
	/*
	 * 최종본
	 */
	 

	INSERT INTO SearchResult
	EXECUTE format(Query, UserNo, SearchText);
	/*
	 * 
	 */





	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1 THEN
	IF (TotalPageCount = 0) SET TotalPageCount = 1 THEN
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount THEN

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := approval_getdocuments.currentpageindex * CountPerPage;
	RETURN QUERY
	SELECT D.DocumentNo, D.RegDate, D.ModUserName, D.ModDepartName, D.Title, D.FileType,
		COALESCE(A.ApproverNo, 0) AS ApproverNo, COALESCE(A.UserName, '') AS ApproverName, A.ArriveDate AS ApproverArriveDate, A.ApprovalDate AS ApproverApprovalDate
	FROM SearchResult T
	INNER JOIN Approval_Documents D ON D.DocumentNo = T.DocumentNo
	LEFT JOIN Approval_Approvers A ON A.ApproverNo = T.ApproverNo
	WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum
	ORDER BY T.RowNum ASC
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalDocumentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
