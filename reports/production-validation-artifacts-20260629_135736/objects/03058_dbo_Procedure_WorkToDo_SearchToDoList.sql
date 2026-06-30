-- ─── PROCEDURE→FUNCTION: worktodo_searchtodolist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
DROP FUNCTION IF EXISTS public.worktodo_searchtodolist(integer, integer, character varying, integer, boolean, integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.worktodo_searchtodolist(
    IN userno integer,
    IN listmode integer,
    IN selectedstate character varying,
    IN sortcolumn integer,
    IN isascending boolean,
    IN countperpage integer,
    IN currentpageindex integer,
    IN searchtext character varying,
    IN searchtype integer
) RETURNS SETOF record
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
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	Query := 'SELECT ROW_NUMBER() OVER (ORDER BY EndDate ASC) RowNum, DataNo ' +;
		'FROM WorkToDo_ToDoList '

	IF ListMode = 1 THEN

		SET Query += 'WHERE RepNo = UserNo'

	END IF;

	ELSIF ListMode = 2 THEN

		SET Query += 'WHERE RepNo = UserNo AND ModUserNo != UserNo'

	END IF;

	ELSIF ListMode = 3 THEN

		SET Query += 'WHERE RepNo = UserNo AND ModUserNo = UserNo'

	END IF;

	ELSIF ListMode = 4 THEN

		SET Query += 'WHERE ModUserNo = UserNo AND RepNo != UserNo'

	END IF;
	
	ELSIF ListMode = 5 THEN
	
		SET Query += 'WHERE RepNo = UserNo AND Passed = 1'
	
	END IF;
	
	-- Selected ToDo State
	SET Query += ' AND State IN (0' || SelectedState || ')'

	--Search text input
	IF (SearchType = 101) BEGIN			-- search by DataNo THEN

		SET Query += ' AND ToDoNo ILIKE ''%' || SearchText || '%'''

	END;

	ELSIF (SearchType = 102) BEGIN		-- search by Subject THEN

		SET Query += ' AND Subject ILIKE ''%' || SearchText || '%'''

	END;

	ELSIF (SearchType = 105) BEGIN		-- search by %Done THEN

		SET Query += ' AND ProgressRate ILIKE ''%' || SearchText || '%%'''

	END;


	INSERT INTO SearchResult
	EXECUTE format(Query, UserNo);
	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1 THEN
	IF (TotalPageCount = 0) SET TotalPageCount = 1 THEN
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount THEN

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := worktodo_searchtodolist.currentpageindex * CountPerPage;
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
