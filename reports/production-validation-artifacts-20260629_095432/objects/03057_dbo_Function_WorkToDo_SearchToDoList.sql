-- ─── FUNCTION: worktodo_searchtodolist ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_searchtodolist(integer, integer, character varying, integer, boolean, integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.worktodo_searchtodolist(
    userno integer,
    listmode integer,
    selectedstate character varying,
    sortcolumn integer,
    isascending boolean,
    countperpage integer,
    currentpageindex integer,
    searchtext character varying,
    searchtype integer
) RETURNS TABLE(
    datano text,
    todono text,
    moduserno text,
    moddate text,
    subject text,
    typeno text,
    repno text,
    startdate text,
    enddate text,
    actualityenddate text,
    progressrate text,
    priority text,
    state text,
    statemoddate text,
    passed text,
    latestjournaldate text
)
AS $function$
DECLARE
    query character varying;
    searchresult table (
		rownum	bigint,
		datano	bigint
	);
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
BEGIN



	SET Query =
		'SELECT ROW_NUMBER() OVER (ORDER BY EndDate ASC) RowNum, DataNo ' +
		'FROM WorkToDo_ToDoList '

	IF (ListMode = 1) BEGIN

		SET Query += 'WHERE RepNo = UserNo'

	END

	ELSE IF (ListMode = 2) BEGIN

		SET Query += 'WHERE RepNo = UserNo AND ModUserNo != UserNo'

	END

	ELSE IF (ListMode = 3) BEGIN

		SET Query += 'WHERE RepNo = UserNo AND ModUserNo = UserNo'

	END

	ELSE IF (ListMode = 4) BEGIN

		SET Query += 'WHERE ModUserNo = UserNo AND RepNo != UserNo'

	END
	
	ELSE IF (ListMode = 5) BEGIN
	
		SET Query += 'WHERE RepNo = UserNo AND Passed = 1'
	
	END
	
	-- Selected ToDo State
	SET Query += ' AND State IN (0' || SelectedState || ')'

	--Search text input
	IF (SearchType = 101) BEGIN			-- search by DataNo

		SET Query += ' AND ToDoNo ILIKE ''%' || SearchText || '%'''

	END

	ELSE IF (SearchType = 102) BEGIN		-- search by Subject

		SET Query += ' AND Subject ILIKE ''%' || SearchText || '%'''

	END

	ELSE IF (SearchType = 105) BEGIN		-- search by %Done

		SET Query += ' AND ProgressRate ILIKE ''%' || SearchText || '%%'''

	END


	INSERT INTO SearchResult
	EXEC SP_EXECUTESQL Query,
		'UserNo AS INT',
		UserNo
	




	SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = worktodo_searchtodolist.currentpageindex * CountPerPage

	RETURN QUERY
	SELECT T.DataNo, ToDoNo, ModUserNo, ModDate, Subject, TypeNo, RepNo,
		StartDate, EndDate, ActualityEndDate, ProgressRate, Priority, State, StateModDate, Passed, LatestJournalDate
	FROM SearchResult T
	INNER JOIN WorkToDo_ToDoList W ON W.DataNo = T.DataNo
	WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum
	ORDER BY T.RowNum ASC

	RETURN QUERY
	SELECT TotalItemCount AS TotalToDoCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex

	RETURN QUERY
	SELECT Query;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
