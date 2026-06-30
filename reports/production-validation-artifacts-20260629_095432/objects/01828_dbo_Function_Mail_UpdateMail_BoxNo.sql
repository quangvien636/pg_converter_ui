-- ─── FUNCTION: mail_updatemail_boxno ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemail_boxno(integer, bigint, bigint);
CREATE OR REPLACE FUNCTION public.mail_updatemail_boxno(
    userno integer,
    mailno bigint,
    boxno bigint
) RETURNS void
AS $function$
DECLARE
    allboxs table (
		boxno	bigint
	);
BEGIN



	INSERT INTO AllBoxs
	SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo)


	SELECT BeforeBoxNo = mail_updatemail_boxno.boxno, ReadDate = ReadDate FROM Mail_Mails WHERE MailNo = mail_updatemail_boxno.mailno



	IF ((SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = BeforeBoxNo) > 0) SET IsBeforeBoxInAllBox = TRUE
	ELSE SET IsBeforeBoxInAllBox = FALSE

	IF ((SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = mail_updatemail_boxno.boxno) > 0) SET IsAfterBoxInAllBox = TRUE
	ELSE SET IsAfterBoxInAllBox = FALSE


	-- 현재, 전체 메일함의 메일 개수를 조정합니다.
	IF (ReadDate IS NULL) BEGIN

		IF (IsBeforeBoxInAllBox = TRUE AND IsAfterBoxInAllBox = FALSE) BEGIN

			UPDATE Mail_MailBoxs SET TotalCount = TotalCount - 1, UnReadCount = UnReadCount - 1
			WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_updatemail_boxno.userno AND ParentNo = -1 AND SortNo = 1)

		END

		ELSE IF (IsBeforeBoxInAllBox = FALSE AND IsAfterBoxInAllBox = TRUE) BEGIN

			UPDATE Mail_MailBoxs SET TotalCount = TotalCount + 1, UnReadCount = UnReadCount + 1
			WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_updatemail_boxno.userno AND ParentNo = -1 AND SortNo = 1)

		END

		UPDATE Mail_MailBoxs SET TotalCount = TotalCount - 1, UnReadCount = UnReadCount - 1 WHERE BoxNo = BeforeBoxNo;
		UPDATE Mail_MailBoxs SET TotalCount = TotalCount + 1, UnReadCount = UnReadCount + 1 WHERE BoxNo = mail_updatemail_boxno.boxno

	END

	ELSE BEGIN

		IF (IsBeforeBoxInAllBox = TRUE AND IsAfterBoxInAllBox = FALSE) BEGIN

			UPDATE Mail_MailBoxs SET TotalCount = TotalCount - 1
			WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_updatemail_boxno.userno AND ParentNo = -1 AND SortNo = 1)

		END

		ELSE IF (IsBeforeBoxInAllBox = FALSE AND IsAfterBoxInAllBox = TRUE) BEGIN

			UPDATE Mail_MailBoxs SET TotalCount = TotalCount + 1
			WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_updatemail_boxno.userno AND ParentNo = -1 AND SortNo = 1)

		END
		
		UPDATE Mail_MailBoxs SET TotalCount = TotalCount - 1 WHERE BoxNo = BeforeBoxNo;
		UPDATE Mail_MailBoxs SET TotalCount = TotalCount + 1 WHERE BoxNo = mail_updatemail_boxno.boxno

	END


	-- 이동시킬 메일함이 휴지통일 경우 예약 메일을 취소합니다.

	SELECT ParentNo = ParentNo, SortNo = SortNo FROM Mail_MailBoxs WHERE BoxNo = mail_updatemail_boxno.boxno

	IF (ParentNo = -1 AND SortNo = 6) BEGIN


		SELECT CMSendNum = CMSendNum, ReserveDate = ReserveDate FROM Mail_Mails WHERE MailNo = mail_updatemail_boxno.mailno
	
		IF (ReserveDate IS NOT NULL) BEGIN

			IF (ReserveDate > NOW()) BEGIN
			
				UPDATE Mail_SentLogs SET IsCancel = TRUE WHERE CMSendNum = CMSendNum;
				UPDATE CrewCloud_MailCenter.public."CMSend" SET RD = 'O' WHERE Num = CMSendNum
		
			END

		END

	END


	-- 지정한 메일함으로 이동시킵니다.;
	UPDATE Mail_Mails SET BoxNo = mail_updatemail_boxno.boxno WHERE MailNo = mail_updatemail_boxno.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
