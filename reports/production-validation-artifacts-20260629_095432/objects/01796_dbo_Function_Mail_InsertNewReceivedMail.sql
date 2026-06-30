-- ─── FUNCTION: mail_insertnewreceivedmail ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertnewreceivedmail(bigint, integer, bigint, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, bigint, character varying, character varying, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.mail_insertnewreceivedmail(
    num bigint,
    userno integer,
    mailboxno bigint,
    fromname character varying,
    fromaddr character varying,
    toaddr character varying,
    cc character varying,
    bcc character varying,
    todomain character varying,
    pop3server character varying,
    popuser character varying,
    title character varying,
    content character varying,
    textmode character varying,
    importance character varying,
    msgsize bigint,
    filelist character varying,
    filesize character varying,
    receivedt timestamp without time zone,
    emlfilenm character varying
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    accountno bigint;
    boxno bigint;
    isspammail boolean;
    statisticsno bigint;
    textmode_ integer;
    files table;
    iscalendar boolean;
    mailno bigint;
    resultcode integer;
    deviceid character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (STRPOS(PopUser, '@') = 0) BEGIN
	
		SET PopUser = mail_insertnewreceivedmail.popuser || '@' || ToDomain
	
	END

	/*
	 * 메일 계정 정보를 확인합니다.
	 */	


	SELECT AccountNo = AccountNo FROM Mail_Accounts
	WHERE MailAddress = mail_insertnewreceivedmail.popuser
	--WHERE UserNo = UserNo AND Server = Pop3Server AND PopUser = PopUser
	--WHERE UserNo = UserNo AND Server = Pop3Server AND PopUser ILIKE PopUser || '%'
	


	/*
	 * 메일이 등록될 메일함 관리번호를 확인합니다.
	 */
	 


	SET IsSpamMail = FALSE
	
	IF (MailBoxNo = 1) BEGIN
	
		SET BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE SortNo = 2 AND UserNo = mail_insertnewreceivedmail.userno AND ParentNo = -1)
		
	END
	
	ELSE IF (MailBoxNo = 4) BEGIN
	
		SET BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_insertnewreceivedmail.userno AND ParentNo = -1 AND SortNo = 5)
		SET IsSpamMail = TRUE
	
	END
	
	ELSE BEGIN
	
		SET BoxNo = mail_insertnewreceivedmail.mailboxno
		
	END
	
	
	
	/*
	 * 메일 통계 데이터를 추가합니다.
	 */
	 

	SELECT StatisticsNo = StatisticsNo FROM Mail_MailReceivedStatistics
	WHERE UserNo = mail_insertnewreceivedmail.userno AND AccNo = AccountNo AND ReceivedDate = CONVERT(DATE, ReceiveDt)

	IF (StatisticsNo IS NULL) BEGIN

		IF (IsSpamMail = FALSE) BEGIN
		
			INSERT INTO Mail_MailReceivedStatistics (UserNo, AccNo, ReceivedDate, NormalCount, SpamCount)
			VALUES(UserNo, AccountNo, ReceiveDt, 1, 0)
			
		END
		
		ELSE BEGIN
		
			INSERT INTO Mail_MailReceivedStatistics (UserNo, AccNo, ReceivedDate, NormalCount, SpamCount)
			VALUES(UserNo, AccountNo, ReceiveDt, 0, 1)
		
		END

	END

	ELSE BEGIN

		IF (IsSpamMail = FALSE) BEGIN
		
			UPDATE Mail_MailReceivedStatistics SET NormalCount = NormalCount + 1
			WHERE StatisticsNo = StatisticsNo

		END
		
		ELSE BEGIN
		
			UPDATE Mail_MailReceivedStatistics SET SpamCount = SpamCount + 1
			WHERE StatisticsNo = StatisticsNo
		
		END

	END
	
	
	
	
	/*
	 *
	 */
	 

	SET TextMode_ = 0
	
	IF (TextMode = 'TEXT') BEGIN
	
		SET TextMode_ = 1
		
	END
	
	ELSE IF (TextMode = 'HTML') BEGIN
	
		SET TextMode_ = 2
		
	END
	
	
	
	/*
	 * 메일 첨부파일 정보를 분석합니다.
	 */
	

	SET Separator = '/'
	SET SeparatorSize = LEN(Separator)
	

	(
		Name NVARCHAR(260),
		Size INT
	)

	IF (LEN(FileList) != 0) BEGIN


		 
		IF RIGHT(FileList, SeparatorSize) != Separator BEGIN
			
			SET FileList = mail_insertnewreceivedmail.filelist + Separator
			
		END
		
		IF RIGHT(FileSize, SeparatorSize) != Separator BEGIN
			
			SET FileSize = mail_insertnewreceivedmail.filesize + Separator
			
		END

		SET FileList = Separator + FileList
		SET FileSize = Separator + FileSize
		
		SET StartIndex = 1
		SET LastIndex = STRPOS(FileList, StartIndex + SeparatorSize, Separator)
		
		SET StartIndex2 = 1
		SET LastIndex2 = STRPOS(FileSize, StartIndex + SeparatorSize, Separator)
		
		SET Count = 0

		WHILE (1 = 1) BEGIN

			SET StartIndex = STRPOS(FileList, Separator)
			SET LastIndex = STRPOS(FileList, StartIndex + SeparatorSize, Separator)
		    
			SET StartIndex2 = STRPOS(FileSize, Separator)
			SET LastIndex2 = STRPOS(FileSize, StartIndex2 + SeparatorSize, Separator)
			
			IF LastIndex <= 0 BEGIN
		    
				BREAK
				
			END
		    
			INSERT INTO Files VALUES (
				SUBSTRING(FileList, StartIndex + SeparatorSize, LastIndex - StartIndex - SeparatorSize),
				SUBSTRING(FileSize, StartIndex2 + SeparatorSize, LastIndex2 - StartIndex2 - SeparatorSize))
				
			SELECT FileList = STUFF(FileList, StartIndex, SeparatorSize, '')
			SELECT FileSize = STUFF(FileSize, StartIndex2, SeparatorSize, '')
			
			SET Count = Count + 1
			
		END
	
	END
	

	
	SET FileCount = (SELECT COUNT(*) FROM Files)
	
	IF (FileCount > 0) SET IsFile = TRUE
	ELSE SET IsFile = FALSE
	

	
	/*
	 * 메일 내용에 일정 데이터가 포함되어 있는지 확인합니다.
	 */
	

	SET IsCalendar = FALSE
	
	IF (SELECT STRPOS(Content, 'BEGIN:VCALENDAR')) = 1 BEGIN
	
		SET IsCalendar = TRUE
	
	END



	/*
	 * 메일 정보를 추가합니다.
	 */

	IF (IsCalendar = FALSE) BEGIN

		INSERT INTO Mail_Mails (
			CMSendNum, UserNo, RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
			ToDomain, AccNo,
			Title, Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsDelete, IsImportant, TagNo, ConversationNo, TextMode, Size, IsFile, FileCount, RegDate, ReserveDate, ReadDate, EmlFileName)
		VALUES(
			Num, UserNo, UserNo, BoxNo, FromName, FromAddr, ToAddr, Cc, Bcc,
			ToDomain, AccountNo,
			Title, Content, 0, 0, Importance, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, TextMode_, MsgSize, IsFile, FileCount, ReceiveDt, NULL, NULL, EmlFileNm)
		
	END
	
	ELSE BEGIN
	
		INSERT INTO Mail_Mails (
			CMSendNum, UserNo, RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
			ToDomain, AccNo,
			Title, Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsDelete, IsImportant, TagNo, TextMode, Size, IsFile, FileCount, RegDate, ReserveDate, ReadDate, EmlFileName)
		VALUES(
			Num, UserNo, UserNo, BoxNo, FromName, FromAddr, ToAddr, Cc, Bcc,
			ToDomain, AccountNo,
			Title, '', 0, 1, Importance, 0, 0, 0, NULL, NULL, 0, 0, 0, TextMode_, MsgSize, IsFile, FileCount, ReceiveDt, NULL, NULL, EmlFileNm)
	
	END
		

	SET MailNo = lastval()
	
	INSERT INTO Mail_MailFiles
	RETURN QUERY
	SELECT MailNo, Name, Size FROM Files
	
	IF (IsCalendar = TRUE) BEGIN
	
		INSERT INTO Mail_MailCalendars (MailNo, Content, IsConvertXml)
		VALUES(MailNo, Content, 0)
	
	END
	


	/*
	 * 메일함 메일 개수
	 */


		
	SET SpamBoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_insertnewreceivedmail.userno AND ParentNo = -1 AND SortNo = 5)
	SET TrashBoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_insertnewreceivedmail.userno AND ParentNo = -1 AND SortNo = 6)
	
	UPDATE Mail_MailBoxs
	SET TotalCount = TotalCount + 1, UnReadCount = UnReadCount + 1
	WHERE BoxNo = BoxNo
	
	IF (SpamBoxNo != BoxNo AND TrashBoxNo != BoxNo) BEGIN
	
		SET AllBoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_insertnewreceivedmail.userno AND ParentNo = -1 AND SortNo = 1)
	
		UPDATE Mail_MailBoxs
		SET TotalCount = TotalCount + 1, UnReadCount = UnReadCount + 1
		WHERE BoxNo = AllBoxNo
	
	END

	UPDATE Mail_UserSettings
	SET CurrentMailBoxSize = CurrentMailBoxSize + MsgSize
	WHERE UserNo = mail_insertnewreceivedmail.userno
	
	

	/*
	 * 대화형 메일
	 */
	 
	--DECLARE ConversationNo BIGINT

	--SELECT /* TOP 1 */ ConversationNo = ConversationNo
	--FROM Mail_MailConversations
	--WHERE RegUserNo = UserNo AND Title ILIKE '%' || Title ESCAPE '['
	--	AND Address ILIKE '%' || FromAddr || '%' ESCAPE '['
	--	AND MailCount != 0
	--ORDER BY ConversationNo DESC

	--IF (ConversationNo IS NULL) BEGIN

	--	SET ConversationNo = 0
		
	--END
	
	--UPDATE Mail_Mails SET ConversationNo = ConversationNo
	--WHERE MailNo = MailNo
	
	--IF (ConversationNo != 0) BEGIN
	
	--	UPDATE Mail_MailConversations SET MailCount = MailCount + 1
	--	WHERE ConversationNo = ConversationNo
		
	--	INSERT INTO Mail_MailThreads (MailNo, ConversationNo)
	--	VALUES (MailNo, ConversationNo)
	
	--END
	


	/*
	 * Notification
	 */

	IF (IsSpamMail = FALSE) BEGIN



		SELECT DeviceID = DeviceID FROM Mail_AndroidDevices WHERE UserNo = mail_insertnewreceivedmail.userno

		IF (DeviceID IS NOT NULL) BEGIN

			IF (LEN(FromName) = 0) BEGIN
				
				SELECT ResultCode = CrewCloud_MailCenter.public."SendGCMNotificationToCrewDDS"(
					DeviceID, UserNo, MailNo, BoxNo,
					FromAddr, Title, Content, ReceiveDt, PopUser)

			END

			ELSE BEGIN

				SELECT ResultCode = CrewCloud_MailCenter.public."SendGCMNotificationToCrewDDS"(
					DeviceID, UserNo, MailNo, BoxNo,
					FromName, Title, Content, ReceiveDt, PopUser)

			END

		END
		
		
		SET DeviceID = NULL
		SELECT DeviceID = DeviceID FROM Mail_IOSDevices WHERE UserNo = mail_insertnewreceivedmail.userno

		IF (DeviceID IS NOT NULL) BEGIN

			IF (LEN(FromName) = 0) BEGIN
				
				SELECT ResultCode = CrewCloud_MailCenter.public."SendAPNSNotificationToCrewDDS"(
					DeviceID, UserNo, MailNo, BoxNo,
					FromAddr, Title, Content, ReceiveDt, PopUser)

			END

			ELSE BEGIN

				SELECT ResultCode = CrewCloud_MailCenter.public."SendAPNSNotificationToCrewDDS"(
					DeviceID, UserNo, MailNo, BoxNo,
					FromName, Title, Content, ReceiveDt, PopUser)

			END

		END

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
