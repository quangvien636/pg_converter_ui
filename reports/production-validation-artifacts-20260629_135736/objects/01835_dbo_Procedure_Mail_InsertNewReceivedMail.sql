-- ─── PROCEDURE→FUNCTION: mail_insertnewreceivedmail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.mail_insertnewreceivedmail(bigint, integer, bigint, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, bigint, character varying, character varying, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.mail_insertnewreceivedmail(
    IN num bigint,
    IN userno integer,
    IN mailboxno bigint,
    IN fromname character varying,
    IN fromaddr character varying,
    IN toaddr character varying,
    IN cc character varying,
    IN bcc character varying,
    IN todomain character varying,
    IN pop3server character varying,
    IN popuser character varying,
    IN title character varying,
    IN content character varying,
    IN textmode character varying,
    IN importance character varying,
    IN msgsize bigint,
    IN filelist character varying,
    IN filesize character varying,
    IN receivedt timestamp without time zone,
    IN emlfilenm character varying
) RETURNS SETOF record
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


	IF STRPOS(PopUser, '@') = 0 THEN
	
		PopUser := mail_insertnewreceivedmail.popuser || '@' || ToDomain;
	END IF;

	/*
	 * 메일 계정 정보를 확인합니다.
	 */	


	SELECT AccountNo INTO accountno FROM Mail_Accounts
	WHERE MailAddress = mail_insertnewreceivedmail.popuser
	--WHERE UserNo = UserNo AND Server = Pop3Server AND PopUser = PopUser
	--WHERE UserNo = UserNo AND Server = Pop3Server AND PopUser ILIKE PopUser || '%'
	


	/*
	 * 메일이 등록될 메일함 관리번호를 확인합니다.
	 */
	 


	IsSpamMail := 0;
	IF MailBoxNo = 1 THEN
	
		BoxNo := (SELECT BoxNo FROM Mail_MailBoxs WHERE SortNo = 2 AND UserNo = mail_insertnewreceivedmail.userno AND ParentNo = -1);
	END IF;
	
	ELSIF MailBoxNo = 4 THEN
	
		BoxNo := (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_insertnewreceivedmail.userno AND ParentNo = -1 AND SortNo = 5);
		IsSpamMail := 1;
	END IF;
	
	ELSE BEGIN
	
		BoxNo := mail_insertnewreceivedmail.mailboxno;
	END;
	
	
	
	/*
	 * 메일 통계 데이터를 추가합니다.
	 */
	 

	SELECT StatisticsNo INTO statisticsno FROM Mail_MailReceivedStatistics
	WHERE UserNo = mail_insertnewreceivedmail.userno AND AccNo = AccountNo AND ReceivedDate = CONVERT(DATE, ReceiveDt)

	IF StatisticsNo IS NULL THEN

		IF IsSpamMail = FALSE THEN
		
			INSERT INTO Mail_MailReceivedStatistics (UserNo, AccNo, ReceivedDate, NormalCount, SpamCount)
			VALUES(UserNo, AccountNo, ReceiveDt, 1, 0)
			
		END IF;
		
		ELSE BEGIN
		
			INSERT INTO Mail_MailReceivedStatistics (UserNo, AccNo, ReceivedDate, NormalCount, SpamCount)
			VALUES(UserNo, AccountNo, ReceiveDt, 0, 1)
		
		END IF;

	END;

	ELSE BEGIN

		IF IsSpamMail = FALSE THEN
		
			UPDATE Mail_MailReceivedStatistics SET NormalCount = NormalCount + 1
			WHERE StatisticsNo = StatisticsNo

		END IF;
		
		ELSE BEGIN
		
			UPDATE Mail_MailReceivedStatistics SET SpamCount = SpamCount + 1
			WHERE StatisticsNo = StatisticsNo
		
		END;

	END;
	
	
	
	
	/*
	 *
	 */
	 

	TextMode_ := 0;
	IF TextMode = 'TEXT' THEN
	
		TextMode_ := 1;
	END IF;
	
	ELSIF TextMode = 'HTML' THEN
	
		TextMode_ := 2;
	END IF;
	
	
	
	/*
	 * 메일 첨부파일 정보를 분석합니다.
	 */
	

	Separator := '/';
	SeparatorSize := LEN(Separator);
	(
		Name NVARCHAR(260),
		Size INT
	)

	IF LEN(FileList) != 0 THEN


		 
		IF RIGHT(FileList, SeparatorSize) != Separator THEN
			
			FileList := mail_insertnewreceivedmail.filelist + Separator;
		END IF;
		
		IF RIGHT(FileSize, SeparatorSize) != Separator THEN
			
			FileSize := mail_insertnewreceivedmail.filesize + Separator;
		END IF;

		FileList := Separator + FileList;
		FileSize := Separator + FileSize;
		StartIndex := 1;
		LastIndex := STRPOS(FileList, StartIndex + SeparatorSize, Separator);
		StartIndex2 := 1;
		LastIndex2 := STRPOS(FileSize, StartIndex + SeparatorSize, Separator);
		Count := 0;
		WHILE 1 = 1 LOOP

			StartIndex := STRPOS(FileList, Separator);
			LastIndex := STRPOS(FileList, StartIndex + SeparatorSize, Separator);
			StartIndex2 := STRPOS(FileSize, Separator);
			LastIndex2 := STRPOS(FileSize, StartIndex2 + SeparatorSize, Separator);
			IF LastIndex <= 0 THEN
		    
				EXIT;
				
			END IF;
		    
			INSERT INTO Files VALUES (
				SUBSTRING(FileList, StartIndex + SeparatorSize, LastIndex - StartIndex - SeparatorSize),
				SUBSTRING(FileSize, StartIndex2 + SeparatorSize, LastIndex2 - StartIndex2 - SeparatorSize))
				
			FileList := (STUFF(FileList, StartIndex, SeparatorSize, ''));
			FileSize := (STUFF(FileSize, StartIndex2, SeparatorSize, ''));
			Count := Count + 1;
		END LOOP;
	
	END IF;
	

	
	FileCount := (SELECT COUNT(*) FROM Files);
	IF (FileCount > 0) SET IsFile = TRUE THEN
	ELSE SET IsFile = FALSE
	

	
	/*
	 * 메일 내용에 일정 데이터가 포함되어 있는지 확인합니다.
	 */
	

	IsCalendar := 0;
	IF (SELECT STRPOS(Content, 'BEGIN:VCALENDAR')) = 1 THEN
	
		IsCalendar := 1;
	END IF;



	/*
	 * 메일 정보를 추가합니다.
	 */

	IF IsCalendar = FALSE THEN

		INSERT INTO Mail_Mails (
			CMSendNum, UserNo, RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
			ToDomain, AccNo,
			Title, Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsDelete, IsImportant, TagNo, ConversationNo, TextMode, Size, IsFile, FileCount, RegDate, ReserveDate, ReadDate, EmlFileName)
		VALUES(
			Num, UserNo, UserNo, BoxNo, FromName, FromAddr, ToAddr, Cc, Bcc,
			ToDomain, AccountNo,
			Title, Content, 0, 0, Importance, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, TextMode_, MsgSize, IsFile, FileCount, ReceiveDt, NULL, NULL, EmlFileNm)
		
	END IF;
	
	ELSE BEGIN
	
		INSERT INTO Mail_Mails (
			CMSendNum, UserNo, RegUserNo, BoxNo, FromName, FromAddr, To, Cc, Bcc,
			ToDomain, AccNo,
			Title, Content, IsSent, IsCalendar, Priority, RecipientsCount, ReadCount, IsOneByOne, ReplyDate, ForwardDate, IsDelete, IsImportant, TagNo, TextMode, Size, IsFile, FileCount, RegDate, ReserveDate, ReadDate, EmlFileName)
		VALUES(
			Num, UserNo, UserNo, BoxNo, FromName, FromAddr, ToAddr, Cc, Bcc,
			ToDomain, AccountNo,
			Title, '', 0, 1, Importance, 0, 0, 0, NULL, NULL, 0, 0, 0, TextMode_, MsgSize, IsFile, FileCount, ReceiveDt, NULL, NULL, EmlFileNm)
	
	END;
		

	MailNo := lastval();;
	INSERT INTO Mail_MailFiles
	RETURN QUERY
	SELECT MailNo, Name, Size FROM Files
	
	IF IsCalendar = TRUE THEN
	
		INSERT INTO Mail_MailCalendars (MailNo, Content, IsConvertXml)
		VALUES(MailNo, Content, 0)
	
	END IF;
	


	/*
	 * 메일함 메일 개수
	 */


		
	SpamBoxNo := (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_insertnewreceivedmail.userno AND ParentNo = -1 AND SortNo = 5);
	TrashBoxNo := (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_insertnewreceivedmail.userno AND ParentNo = -1 AND SortNo = 6);;
	UPDATE Mail_MailBoxs
	TotalCount := TotalCount + 1, UnReadCount = UnReadCount + 1;
	WHERE BoxNo = BoxNo
	
	IF SpamBoxNo != BoxNo AND TrashBoxNo != BoxNo THEN
	
		AllBoxNo := (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_insertnewreceivedmail.userno AND ParentNo = -1 AND SortNo = 1);;
		UPDATE Mail_MailBoxs
		TotalCount := TotalCount + 1, UnReadCount = UnReadCount + 1;
		WHERE BoxNo = AllBoxNo
	
	END IF;

	UPDATE Mail_UserSettings
	CurrentMailBoxSize := CurrentMailBoxSize + MsgSize;
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

	IF IsSpamMail = FALSE THEN



		SELECT DeviceID INTO deviceid FROM Mail_AndroidDevices WHERE UserNo = mail_insertnewreceivedmail.userno

		IF DeviceID IS NOT NULL THEN

			IF LEN(FromName) = 0 THEN
				
				ResultCode := (CrewCloud_MailCenter.public."SendGCMNotificationToCrewDDS"();
					DeviceID, UserNo, MailNo, BoxNo,
					FromAddr, Title, Content, ReceiveDt, PopUser)

			END IF;

			ELSE BEGIN

				ResultCode := (CrewCloud_MailCenter.public."SendGCMNotificationToCrewDDS"();
					DeviceID, UserNo, MailNo, BoxNo,
					FromName, Title, Content, ReceiveDt, PopUser)

			END IF;

		END IF;
		
		
		DeviceID := NULL;
		SELECT DeviceID INTO deviceid FROM Mail_IOSDevices WHERE UserNo = mail_insertnewreceivedmail.userno

		IF DeviceID IS NOT NULL THEN

			IF LEN(FromName) = 0 THEN
				
				ResultCode := (CrewCloud_MailCenter.public."SendAPNSNotificationToCrewDDS"();
					DeviceID, UserNo, MailNo, BoxNo,
					FromAddr, Title, Content, ReceiveDt, PopUser)

			END IF;

			ELSE BEGIN

				ResultCode := (CrewCloud_MailCenter.public."SendAPNSNotificationToCrewDDS"();
					DeviceID, UserNo, MailNo, BoxNo,
					FromName, Title, Content, ReceiveDt, PopUser)

			END IF;

		END;

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
