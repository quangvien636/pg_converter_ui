-- ─── FUNCTION: mail_getmails_back ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmails_back(integer, integer, character varying, bigint, bigint, bigint, integer, bigint, integer, boolean, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.mail_getmails_back(
    userno integer,
    searchtype integer,
    searchtext character varying,
    accno bigint,
    boxno bigint,
    parentno bigint,
    sortno integer,
    quicksearchmode bigint,
    sortcolumn integer,
    isascending boolean,
    countperpage integer,
    currentpageindex integer,
    isconversation boolean
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
    searchresult3 table (
		rownum			bigint,
		mailno			bigint,
		conversationno	bigint
	);
    searchresult2 table (
			rownum			bigint,
			mailno			bigint,
			conversationno	bigint
		);
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
    searchresult4 table (
			mailno		bigint
		);
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
	 * 전체메일함 여부 확인
	 */

	IF (ParentNo = -1 AND SortNo = 1) BEGIN

		SET Query = (
			'DECLARE ExcludedMailboxes TABLE ( BoxNo BIGINT )' +
			'INSERT INTO ExcludedMailboxes ' +
			'SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo) '
			) + Query

		SET Query += 'AND BoxNo IN (SELECT * FROM ExcludedMailboxes) '
		
	END
	
	ELSE IF (ParentNo = -1 AND SortNo = 7) BEGIN
	
		SET Query = (
			'DECLARE ExcludedMailboxes TABLE ( BoxNo BIGINT )' +
			'INSERT INTO ExcludedMailboxes ' +
			'SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo) '
			) + Query

		SET Query += 'AND BoxNo IN (SELECT * FROM ExcludedMailboxes) AND ReadDate IS NULL '
	
	END

	ELSE BEGIN
	
		SET Query += 'AND BoxNo = BoxNo '
		
	END

	IF (AccNo = -1) SET Query += 'AND IsDelete = FALSE '
	ELSE SET Query += 'AND AccNo = AccNo AND IsDelete = FALSE '



	/*
	 * 빠른 검색 
	 */

	IF (QuickSearchMode = 1) SET Query += ''
	ELSE IF (QuickSearchMode = 2) SET Query += 'AND ReadDate IS NOT NULL '
	ELSE IF (QuickSearchMode = 3) SET Query += 'AND ReadDate IS NULL '
	ELSE IF (QuickSearchMode = 4) SET Query += 'AND IsImportant = TRUE '
	ELSE IF (QuickSearchMode = 5) SET Query += 'AND FileCount != 0 '
	ELSE IF (QuickSearchMode >= 20) SET Query += 'AND TagNo = ' || CONVERT(VARCHAR, QuickSearchMode) + ' '



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
		ELSE IF (SearchType = 3) SET Query += 'AND (FromName + FromAddr) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
		ELSE IF (SearchType = 4) SET Query += 'AND RegDate ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' '
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
		'UserNo AS INT, BoxNo AS BIGINT, AccNo AS BIGINT, SearchText AS NVARCHAR(100)',
		UserNo, BoxNo, AccNo, SearchText
	
	
	
	/*
	 *
	 */


	IF IsConversation = TRUE BEGIN


		INSERT INTO SearchResult2
		RETURN QUERY
		SELECT RowNum, MailNo, 0 FROM SearchResult WHERE ConversationNo = 0

		INSERT INTO SearchResult2
		RETURN QUERY
		SELECT RowNum, T.MailNo, T.ConversationNo FROM SearchResult T
		INNER JOIN (
			SELECT MAX(MailNo) AS MailNo, ConversationNo
			FROM SearchResult
			WHERE ConversationNo != 0
			GROUP BY ConversationNo
		) C ON C.MailNo = T.MailNo

		INSERT INTO SearchResult3
		RETURN QUERY
		SELECT ROW_NUMBER() OVER (ORDER BY RowNum ASC) AS RowNum, MailNo, ConversationNo
		FROM SearchResult2

	END

	ELSE BEGIN

		INSERT INTO SearchResult3
		RETURN QUERY
		SELECT RowNum, MailNo, ConversationNo FROM SearchResult

	END

	
	
	/*
	 * 
	 */





	SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult3)
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = mail_getmails_back.currentpageindex * CountPerPage

	IF (ParentNo = -1 AND SortNo = 1) BEGIN

		RETURN QUERY
		SELECT M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
			AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
			Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
		FROM SearchResult3 T
		INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
		INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
		LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_back.userno) MT ON MT.TagNo = M.TagNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum
		ORDER BY T.RowNum ASC

	END
	
	ELSE BEGIN

		RETURN QUERY
		SELECT M.MailNo, CMSendNum, M.RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
			AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
			Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate
		FROM SearchResult3 T
		INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
		LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_back.userno) MT ON MT.TagNo = M.TagNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum
		ORDER BY T.RowNum ASC
		
	END
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalMailCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex
	
	IF IsConversation = TRUE BEGIN
	

		INSERT INTO SearchResult4
		RETURN QUERY
		SELECT MailNo FROM Mail_Mails
		WHERE UserNo = mail_getmails_back.userno AND IsDelete = FALSE AND ConversationNo IN (SELECT T3.ConversationNo FROM SearchResult3 T3)
	
		RETURN QUERY
		SELECT M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
			AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
			Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
		FROM SearchResult4 T
		INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
		INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
		LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags) MT ON MT.TagNo = M.TagNo
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
