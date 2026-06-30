-- ─── FUNCTION: approval_getdocuments ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getdocuments(integer, integer, integer, character varying, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_getdocuments(
    userno integer,
    boxtype integer,
    searchtype integer,
    searchtext character varying,
    sortcolumn integer,
    isascending boolean,
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    documentno text,
    regdate text,
    modusername text,
    moddepartname text,
    title text,
    filetype text,
    approverno text,
    approvername text,
    approverarrivedate text,
    approverapprovaldate text
)
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
BEGIN


	/*
	 * 쿼리 조합 시작
	 */
	 

	SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '



	/*
	 * 정렬 컬럼
	 */
		 
	IF (SortColumn = 1) SET Query += 'D.DocumentNo '
	ELSE IF (SortColumn = 2) SET Query += 'D.Title '
	ELSE IF (SortColumn = 3) SET Query += 'D.ModDepartName '
	ELSE IF (SortColumn = 4) SET Query += 'D.ModUserName '
	ELSE IF (SortColumn = 5) SET Query += 'A2.UserName '
	ELSE IF (SortColumn = 6) SET Query += 'D.RegDate '
	ELSE IF (SortColumn = 7) SET Query += 'A.ArriveDate '
	ELSE IF (SortColumn = 8) SET Query += 'A2.ArriveDate '
	ELSE IF (SortColumn = 9) SET Query += 'A2.ApprovalDate '
	ELSE IF (SortColumn = 10) SET Query += 'A.ApprovalDate '



	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC '
	ELSE SET Query += 'DESC '


	SET Query += ') RowNum, D.DocumentNo, '



	/*
	 * 문서 목록
	 */
	 
	IF (BoxType = 101) BEGIN  /* 결재함 - 결재 */

		SET Query +=
			'A.ApproverNo AS ApproverNo ' +
			
			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'WHERE D.State = 200 AND A.UserNo = UserNo AND A.ApprovalType = 200 AND A.ArriveState = 200 '

	END

	ELSE IF (BoxType = 103) BEGIN /* 결재함 - 합의 */

		SET Query +=
			'A.ApproverNo AS ApproverNo ' +
			
			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'WHERE D.State = 200 AND A.UserNo = UserNo AND A.ApprovalType = 300 AND A.ArriveState = 200 '
			
	END

	ELSE IF (BoxType = 105) BEGIN /* 결재함 - 수신 */

		SET Query +=
			'A.ApproverNo AS ApproverNo ' +
			
			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'WHERE D.State = 300 AND A.UserNo = UserNo AND A.ApprovalType = 600 AND A.ArriveState = 200 '
			
	END

	ELSE IF (BoxType = 107) BEGIN /* 결재함 - 보류 */

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +
			
			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 500 AND A.UserNo = UserNo AND A.ArriveState != 100 '
			
	END

	ELSE IF (BoxType = 108) BEGIN /* 결재함 - 진행 */

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 200 AND A.UserNo = UserNo AND A.ArriveState = 300 '
			
	END

	ELSE IF (BoxType = 201) BEGIN /* 기안함 - 진행 */

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 200 AND D.ModUserNo = UserNo '

	END

	ELSE IF (BoxType = 202) BEGIN /* 기안함 - 보류*/

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 500 AND D.ModUserNo = UserNo '

	END

	ELSE IF (BoxType = 203) BEGIN /* 기안함 - 반려 */

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 400 AND D.ModUserNo = UserNo '
			
	END

	ELSE IF (BoxType = 204) BEGIN /* 기안함 - 완료 */

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 300 AND D.ModUserNo = UserNo '
			
	END

	ELSE IF (BoxType = 301) BEGIN  /* 종결함 - 완료 */

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 300 AND A.UserNo = UserNo AND A.ArriveState = 300 AND A.ApprovalType IN (200, 300) '

	END

	ELSE IF (BoxType = 302) BEGIN /* 종결함 - 반려*/

		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'LEFT JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 400 AND A.UserNo = UserNo AND A.ArriveState = 300 '
			
	END

	ELSE IF (BoxType = 403) BEGIN /* 문서수발신함 - 완료 */

		SET Query +=
			'A.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A ON A.DocumentNo = D.DocumentNo ' +
			'WHERE D.State = 300 AND A.UserNo = UserNo AND A.ApprovalType = 600 AND A.ArriveState = 300 '

	END
	
	ELSE IF (BoxType = 501) BEGIN /* 전사문서함 - 진행 */
	
		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 200 '
	END
	
	ELSE IF (BoxType = 502) BEGIN /* 전사문서함 - 보류 */
	
		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 500 '
	END
	
	ELSE IF (BoxType = 503) BEGIN /* 전사문서함 - 반려 */
	
		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 400 '
	END

	ELSE IF (BoxType = 504) BEGIN /* 전사문서함 - 완료 */
	
		SET Query +=
			'A2.ApproverNo AS ApproverNo ' +

			'FROM Approval_Documents D ' +
			'INNER JOIN Approval_Approvers A2 ON A2.ApproverNo = D.CurrentAppNo ' +
			'WHERE D.State = 300 '
	END



	/*
	 * 검색 조건
	 */
	 
	IF (SearchText != '') BEGIN

		IF (SearchType = 1) SET Query += 'AND D.DocumentNo = SearchText '
		ELSE IF (SearchType = 2) SET Query += 'AND D.Title ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 3) SET Query += 'AND D.ModDepartName ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 4) SET Query += 'AND D.ModUserName ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 5) SET Query += 'AND A2.UserName ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 6) SET Query += 'AND D.RegDate ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 7) SET Query += 'AND A.ArriveDate ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 8) SET Query += 'AND A2.ArriveDate ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 9) SET Query += 'AND A2.ApprovalDate ILIKE ''%'' || SearchText || ''%'' '
		ELSE IF (SearchType = 10) SET Query += 'AND A.ApprovalDate ILIKE ''%'' || SearchText || ''%'' '

	END
	
	
	
	/*
	 * 최종본
	 */
	 

	INSERT INTO SearchResult
	EXEC SP_EXECUTESQL Query, 'UserNo AS INT, SearchText AS NVARCHAR(100)', UserNo, SearchText



	/*
	 * 
	 */





	SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = approval_getdocuments.currentpageindex * CountPerPage

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
