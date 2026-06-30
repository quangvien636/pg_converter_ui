-- ─── PROCEDURE→FUNCTION: mail_getmails_forscrollpaging ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: dynamic SQL converted best-effort; review EXECUTE statement
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.mail_getmails_forscrollpaging(integer, integer, character varying, bigint, bigint, bigint, integer, boolean, bigint);
CREATE OR REPLACE FUNCTION public.mail_getmails_forscrollpaging(
    IN userno integer,
    IN searchtype integer,
    IN searchtext character varying,
    IN accno bigint,
    IN boxno bigint,
    IN parentno bigint,
    IN sortno integer,
    IN isdownward boolean,
    IN anchormailno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    query character varying;
    searchresult table (
		rownum	bigint,
		mailno	bigint
	);
    anchorrownum bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	/*
	 * 쿼리 조합 시작
	 */
	 

	Query := 'SELECT ROW_NUMBER() OVER (ORDER BY COALESCE(ReserveDate, RegDate) DESC) RowNum, MailNo ' +;
		'FROM Mail_Mails WHERE UserNo = UserNo '



	/*
	 * 전체메일함 여부 확인
	 */

	IF ParentNo = -1 AND SortNo = 1 THEN

		Query := (;
			'' +
			'INSERT INTO ExcludedMailboxes ' +
			'SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo) '
			) + Query

		SET Query += 'AND BoxNo IN (SELECT * FROM ExcludedMailboxes) '
		
	END IF;

	ELSIF ParentNo = -1 AND SortNo = 7 THEN

		Query := (;
			'' +
			'INSERT INTO ExcludedMailboxes ' +
			'SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo) '
			) + Query

		SET Query += 'AND BoxNo IN (SELECT * FROM ExcludedMailboxes) AND ReadDate IS NULL '
		
	END IF;

	ELSE BEGIN

		SET Query += 'AND BoxNo = BoxNo '
		
	END;

	IF (AccNo = -1) SET Query += 'AND IsDelete = FALSE ' THEN
	ELSE SET Query += 'AND AccNo = AccNo AND IsDelete = FALSE '



	/*
	 * 검색 조건
	 */
	 
	IF SearchText != '' THEN

		IF (SearchType = 1) SET Query += 'AND Title ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF (SearchType = 2) SET Query += 'AND (To + Cc + Bcc) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF (SearchType = 3) SET Query += 'AND (FromName + FromAddr) ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF (SearchType = 4) SET Query += 'AND RegDate ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF (SearchType = 6) SET Query += 'AND To ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF (SearchType = 7) SET Query += 'AND Cc ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN
		ELSIF (SearchType = 8) SET Query += 'AND Bcc ILIKE ''%'' || SearchText || ''%'' ESCAPE ''['' ' THEN

	END IF;



	INSERT INTO SearchResult
	EXECUTE format(Query, UserNo, BoxNo, AccNo, SearchText);
    /*
     * 메일 목록을 가져옵니다.
     */
     

	AnchorRowNum := 0;
	IF AnchorMailNo != 0 THEN

		SELECT RowNum INTO anchorrownum FROM SearchResult WHERE MailNo = mail_getmails_forscrollpaging.anchormailno
		
	END IF;

	IF IsDownward = TRUE THEN

		IF ParentNo = -1 AND SortNo = 1 THEN

			RETURN QUERY
			SELECT /* TOP 20 */ M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
				AccNo, Title, Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
				Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
			FROM SearchResult T
			INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
			INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
			LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_forscrollpaging.userno) MT ON MT.TagNo = M.TagNo
			WHERE T.RowNum > AnchorRowNum
			ORDER BY T.RowNum ASC
		
		END IF;
		
		ELSE BEGIN
		
			RETURN QUERY
			SELECT /* TOP 20 */ M.MailNo, CMSendNum, M.RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
				AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
				Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate
			FROM SearchResult T
			INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
			LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_forscrollpaging.userno) MT ON MT.TagNo = M.TagNo
			WHERE T.RowNum > AnchorRowNum
			ORDER BY T.RowNum ASC
		
		END IF;
		
	END;

	ELSE BEGIN

		IF ParentNo = -1 AND SortNo = 1 THEN
		
			RETURN QUERY
			SELECT M.MailNo, CMSendNum, M.RegUserNo, MB.BoxNo, FromName, FromAddr, To, Cc, Bcc,
				AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
				Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate, MB.Name AS BoxName
			FROM SearchResult T
			INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
			INNER JOIN Mail_MailBoxs MB ON MB.BoxNo = M.BoxNo
			LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_forscrollpaging.userno) MT ON MT.TagNo = M.TagNo
			WHERE T.RowNum < AnchorRowNum
			ORDER BY T.RowNum ASC

		END IF;
		
		ELSE BEGIN
		
			RETURN QUERY
			SELECT M.MailNo, CMSendNum, M.RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
				AccNo, Title, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsImportant, M.TagNo, COALESCE(MT.ImageNo, 0) AS TagImageNo, M.ConversationNo,
				Size, IsFile, FileCount, RegDate, ReserveDate, M.ReadDate
			FROM SearchResult T
			INNER JOIN Mail_Mails M ON M.MailNo = T.MailNo
			LEFT JOIN (SELECT TagNo, ImageNo FROM Mail_MailTags WHERE UserNo = mail_getmails_forscrollpaging.userno) MT ON MT.TagNo = M.TagNo
			WHERE T.RowNum < AnchorRowNum
			ORDER BY T.RowNum ASC
			
		END;

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
