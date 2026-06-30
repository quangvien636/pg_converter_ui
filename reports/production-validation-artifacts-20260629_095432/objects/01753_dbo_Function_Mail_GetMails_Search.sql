-- ─── FUNCTION: mail_getmails_search ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmails_search(integer, integer, character varying, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_getmails_search(
    userno integer,
    searchtype integer,
    searchtext character varying,
    sortcolumn integer,
    isascending boolean,
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    tagno text,
    imageno text
)
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
BEGIN


	/*
	 * 쿼리 조합 시작
	 */



	SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '



	/*
	 * 정렬 컬럼
	 */

	IF (SortColumn = 1) SET Query += 'FromName + FromAddr '
	ELSE IF (SortColumn = 2) SET Query += 'To '
	ELSE IF (SortColumn = 3) SET Query += 'Title '
	ELSE IF (SortColumn = 4) SET Query += 'COALESCE(ReserveDate, RegDate) '
	ELSE IF (SortColumn = 5) SET Query += 'Size '
	ELSE IF (SortColumn = 6) SET Query += 'IsImportant '
	ELSE IF (SortColumn = 7) SET Query += 'ReadDate '
	ELSE IF (SortColumn = 8) SET Query += 'IsFile '



	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC '
	ELSE SET Query += 'DESC '

	IF (SortColumn = 6 OR SortColumn = 7 OR SortColumn = 8) BEGIN
	
		SET Query += ', COALESCE(ReserveDate, RegDate) DESC '
		
	END



	/*
	 * WHERE 조합 시작
	 */

	SET Query +=
		') RowNum, MailNo, ConversationNo ' +
		'FROM Mail_Mails WHERE UserNo = UserNo '


	/*
	 * 검색 조건
	 */

	IF (SearchText != '') BEGIN

		IF (SearchType = 1) SET Query += 'AND Title ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		--ELSE IF (SearchType = 2) SET Query += 'AND (To + Cc + Bcc) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSE IF (SearchType = 2) 
		BEGIN
			SET subWhere = STUFF(
			(
				SELECT ' OR (To + Cc + Bcc) ILIKE ''%#user_' || Convert(varchar,UserNo) + '%''' 
				FROM Organization_Users t where Name ILIKE '%' || SearchText || '%' FOR XML PATH('')
			), 1, 4, '')
			--print(subWhere)
			IF(subWhere != '' and subWhere is not null)
			BEGIN
				SET Query += 'AND ((To + Cc + Bcc) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' OR (' || subWhere || '))'
			END
			ELSE
			BEGIN
				SET Query += 'AND (To + Cc + Bcc) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
			END
		END
		ELSE IF (SearchType = 3) SET Query += 'AND (FromName + FromAddr) ILIKE ''%'' || REPLACE(REPLACE(SearchText,''['',''/[''),'']'',''/]'')  + ''%'' ESCAPE ''/'' '
		ELSE IF (SearchType = 4) SET Query += 'AND CONVERT(VARCHAR(25), RegDate, 126) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSE IF (SearchType = 6) 
		BEGIN
			SET subWhere = STUFF(
			(
				SELECT ' OR To ILIKE ''%#user_' || Convert(varchar,UserNo) + '%''' 
				FROM Organization_Users t where Name ILIKE '%' || SearchText || '%' FOR XML PATH('')
			), 1, 4, '')
			--print(subWhere)
			IF(subWhere != '' and subWhere is not null)
			BEGIN
				SET Query += 'AND (To ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' OR (' || subWhere || '))'
			END
			ELSE
			BEGIN
				SET Query += 'AND To ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
			END
		END
		ELSE IF (SearchType = 7) 
		BEGIN
			SET subWhere = STUFF(
			(
				SELECT ' OR Cc ILIKE ''%#user_' || Convert(varchar,UserNo) + '%''' 
				FROM Organization_Users t where Name ILIKE '%' || SearchText || '%' FOR XML PATH('')
			), 1, 4, '')
			--print(subWhere)
			IF(subWhere != '' and subWhere is not null)
			BEGIN
				SET Query += 'AND (Cc ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' OR (' || subWhere || '))'
			END
			ELSE
			BEGIN
				SET Query += 'AND Cc ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
			END
		END
		ELSE IF (SearchType = 8) 
		BEGIN
			SET subWhere = STUFF(
			(
				SELECT ' OR Bcc ILIKE ''%#user_' || Convert(varchar,UserNo) + '%''' 
				FROM Organization_Users t where Name ILIKE '%' || SearchText || '%' FOR XML PATH('')
			), 1, 4, '')
			--print(subWhere)
			IF(subWhere != '' and subWhere is not null)
			BEGIN
				SET Query += 'AND (Bcc ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' OR (' || subWhere || '))'
			END
			ELSE
			BEGIN
				SET Query += 'AND Bcc ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
			END
		END
	END



	--print(Query);
	INSERT INTO SearchResult
	EXEC SP_EXECUTESQL Query,
		'UserNo AS INT, SearchText AS NVARCHAR(100)',
		UserNo, SearchText
	









	SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = mail_getmails_search.currentpageindex * CountPerPage

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
