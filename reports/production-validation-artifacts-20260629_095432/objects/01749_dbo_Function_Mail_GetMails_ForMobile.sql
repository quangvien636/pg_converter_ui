-- ─── FUNCTION: mail_getmails_formobile ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmails_formobile(integer, integer, character varying, bigint, bigint, bigint, integer, bigint, integer, boolean, boolean, bigint, integer);
CREATE OR REPLACE FUNCTION public.mail_getmails_formobile(
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
    isdownward boolean,
    anchormailno bigint,
    readcount integer
) RETURNS TABLE(
    tagno text,
    imageno text
)
AS $function$
DECLARE
    query character varying;
    subwhere character varying;
    searchresult table (
		rownum	bigint,
		mailno	bigint
	);
    anchorrownum bigint;
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
		') RowNum, MailNo ' +
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



	INSERT INTO SearchResult
	EXEC SP_EXECUTESQL Query,
		'UserNo AS INT, BoxNo AS BIGINT, AccNo AS BIGINT, SearchText AS NVARCHAR(100)',
		UserNo, BoxNo, AccNo, SearchText
		

    /*
     * 메일 목록을 가져옵니다.
     */
     

	SET AnchorRowNum = 0

	IF (AnchorMailNo != 0 ) BEGIN

		SELECT AnchorRowNum = RowNum FROM SearchResult WHERE MailNo = mail_getmails_formobile.anchormailno
		
	END

	IF (IsDownward = TRUE) BEGIN

		IF (ParentNo = -1 AND SortNo = 1) BEGIN

			RETURN QUERY
			SELECT TOP (ReadCount) M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
				AccNo, Title, SUBSTRING(Content, 0, 300) AS Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
				Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
			FROM SearchResult T
			INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
			INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
			LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_formobile.userno) MT ON MT.TagNo = M.TagNo
			WHERE T.RowNum > AnchorRowNum
			ORDER BY T.RowNum ASC
		
		END
		
		ELSE BEGIN
		
			RETURN QUERY
			SELECT TOP (ReadCount) M.MailNo, CMSendNum, M.RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
				AccNo, Title, SUBSTRING(Content, 0, 300) AS Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
				Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate
			FROM SearchResult T
			INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
			LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_formobile.userno) MT ON MT.TagNo = M.TagNo
			WHERE T.RowNum > AnchorRowNum
			ORDER BY T.RowNum ASC
		
		END
		
	END

	ELSE BEGIN

		IF (ParentNo = -1 AND SortNo = 1) BEGIN
		
			RETURN QUERY
			SELECT M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
				AccNo, Title, SUBSTRING(Content, 0, 300) AS Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
				Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
			FROM SearchResult T
			INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
			INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
			LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_formobile.userno) MT ON MT.TagNo = M.TagNo
			WHERE T.RowNum < AnchorRowNum
			ORDER BY T.RowNum ASC

		END
		
		ELSE BEGIN
		
			RETURN QUERY
			SELECT M.MailNo, CMSendNum, M.RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
				AccNo, Title, SUBSTRING(Content, 0, 300) AS Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
				Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate
			FROM SearchResult T
			INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
			LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_formobile.userno) MT ON MT.TagNo = M.TagNo
			WHERE T.RowNum < AnchorRowNum
			ORDER BY T.RowNum ASC
			
		END

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
