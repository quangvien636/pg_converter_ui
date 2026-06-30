-- ─── PROCEDURE→FUNCTION: mail_getmails_search ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
DROP FUNCTION IF EXISTS public.mail_getmails_search(integer, integer, character varying, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_getmails_search(
    IN userno integer,
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
    subwhere character varying;
    searchresult table (
		rownum			bigint,
		mailno			bigint,
		conversationno	bigint
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

	IF (SortColumn = 1) SET Query += 'FromName + FromAddr ' THEN
	ELSIF (SortColumn = 2) SET Query += 'To ' THEN
	ELSIF (SortColumn = 3) SET Query += 'Title ' THEN
	ELSIF (SortColumn = 4) SET Query += 'COALESCE(ReserveDate, RegDate) ' THEN
	ELSIF (SortColumn = 5) SET Query += 'Size ' THEN
	ELSIF (SortColumn = 6) SET Query += 'IsImportant ' THEN
	ELSIF (SortColumn = 7) SET Query += 'ReadDate ' THEN
	ELSIF (SortColumn = 8) SET Query += 'IsFile ' THEN



	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC ' THEN
	ELSE SET Query += 'DESC '

	IF SortColumn = 6 OR SortColumn = 7 OR SortColumn = 8 THEN
	
		SET Query += ', COALESCE(ReserveDate, RegDate) DESC '
		
	END IF;



	/*
	 * WHERE 조합 시작
	 */

	SET Query +=
		') RowNum, MailNo, ConversationNo ' +
		'FROM Mail_Mails WHERE UserNo = UserNo '


	/*
	 * 검색 조건
	 */

	IF SearchText != '' THEN

		IF (SearchType = 1) SET Query += 'AND Title ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		--ELSE IF (SearchType = 2) SET Query += 'AND (To + Cc + Bcc) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSIF SearchType = 2 THEN
			subWhere := STUFF(;
			(
				SELECT ' OR (To + Cc + Bcc) ILIKE ''%user_' || Convert(varchar,UserNo) + '%''' 
				FROM Organization_Users t where Name ILIKE '%' || SearchText || '%' FOR XML PATH('')
			), 1, 4, '')
			--print(subWhere)
			IF(subWhere != '' and subWhere is not null)
			BEGIN
				SET Query += 'AND ((To + Cc + Bcc) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' OR (' || subWhere || '))'
			END;
			ELSE
				SET Query += 'AND (To + Cc + Bcc) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
			END IF;
		END IF;
		ELSIF (SearchType = 3) SET Query += 'AND (FromName + FromAddr) ILIKE ''%'' || REPLACE(REPLACE(SearchText,''['',''/[''),'']'',''/]'')  + ''%'' ESCAPE ''/'' ' THEN
		ELSIF (SearchType = 4) SET Query += 'AND CONVERT(VARCHAR(25), RegDate, 126) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF SearchType = 6 THEN
			subWhere := STUFF(;
			(
				SELECT ' OR To ILIKE ''%user_' || Convert(varchar,UserNo) + '%''' 
				FROM Organization_Users t where Name ILIKE '%' || SearchText || '%' FOR XML PATH('')
			), 1, 4, '')
			--print(subWhere)
			IF(subWhere != '' and subWhere is not null)
			BEGIN
				SET Query += 'AND (To ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' OR (' || subWhere || '))'
			END;
			ELSE
				SET Query += 'AND To ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
			END IF;
		END IF;
		ELSIF SearchType = 7 THEN
			subWhere := STUFF(;
			(
				SELECT ' OR Cc ILIKE ''%user_' || Convert(varchar,UserNo) + '%''' 
				FROM Organization_Users t where Name ILIKE '%' || SearchText || '%' FOR XML PATH('')
			), 1, 4, '')
			--print(subWhere)
			IF(subWhere != '' and subWhere is not null)
			BEGIN
				SET Query += 'AND (Cc ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' OR (' || subWhere || '))'
			END;
			ELSE
				SET Query += 'AND Cc ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
			END IF;
		END IF;
		ELSIF SearchType = 8 THEN
			subWhere := STUFF(;
			(
				SELECT ' OR Bcc ILIKE ''%user_' || Convert(varchar,UserNo) + '%''' 
				FROM Organization_Users t where Name ILIKE '%' || SearchText || '%' FOR XML PATH('')
			), 1, 4, '')
			--print(subWhere)
			IF(subWhere != '' and subWhere is not null)
			BEGIN
				SET Query += 'AND (Bcc ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' OR (' || subWhere || '))'
			END;
			ELSE
				SET Query += 'AND Bcc ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
			END IF;
		END IF;
	END IF;



	--print(Query);
	INSERT INTO SearchResult
	EXECUTE format(Query, UserNo, SearchText);
	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1 THEN
	IF (TotalPageCount = 0) SET TotalPageCount = 1 THEN
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount THEN

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := mail_getmails_search.currentpageindex * CountPerPage;
	RETURN QUERY
	SELECT M.MailNo, CMSendNum, M.RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
		AccNo, Title, Content ,IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
		Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate
	FROM SearchResult T
	INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
	LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_search.userno) MT ON MT.TagNo = M.TagNo
	WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum
	ORDER BY T.RowNum ASC
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalMailCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
