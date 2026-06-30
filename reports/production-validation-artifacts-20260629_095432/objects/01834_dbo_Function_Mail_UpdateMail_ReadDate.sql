-- ─── FUNCTION: mail_updatemail_readdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemail_readdate(integer, bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_updatemail_readdate(
    userno integer,
    mailno bigint,
    readdate timestamp without time zone
) RETURNS TABLE(
    boxno text
)
AS $function$
DECLARE
    allboxs table (
		boxno	bigint
	);
    mailaddress character varying;
BEGIN



	
	RETURN QUERY
	SELECT
		CMSendNum = CMSendNum,
		BoxNo = BoxNo,
		AccNo = AccNo,
		TagNo = TagNo,
		_ReadDate = mail_updatemail_readdate.readdate,
		IsDelete = IsDelete
	FROM Mail_Mails WHERE MailNo = mail_updatemail_readdate.mailno
	
	IF _ReadDate IS NULL AND ReadDate IS NULL BEGIN

		RETURN

	END

	IF _ReadDate IS NOT NULL AND ReadDate IS NOT NULL BEGIN

		RETURN

	END

	IF IsDelete = TRUE BEGIN

		RETURN

	END



	INSERT INTO AllBoxs
	RETURN QUERY
	SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo)



	IF (ReadDate IS NOT NULL) BEGIN

		-- 태그별 메일 개수를 조정합니다.
		IF (TagNo != 0) BEGIN

			UPDATE Mail_MailTags SET UnReadCount = UnReadCount - 1 WHERE TagNo = TagNo

		END


		-- 현재, 전체 메일함의 메일 개수를 조정합니다.
		IF ((SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = BoxNo) > 0) BEGIN

			UPDATE Mail_MailBoxs SET UnReadCount = UnReadCount - 1
			WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_updatemail_readdate.userno AND ParentNo = -1 AND SortNo = 1)

		END

		UPDATE Mail_MailBoxs SET UnReadCount = UnReadCount - 1 WHERE BoxNo = BoxNo


		-- 수신 이력를 추가합니다.
		IF (CMSendNum != 0) BEGIN
	

			SELECT MailAddress = MailAddress FROM Mail_Accounts WHERE AccountNo = AccNo
	
			EXEC Mail_UpdateSentLog_ReadDate CMSendNum, MailAddress, 0
			
		END


		-- 메일 읽음 날짜를 변경합니다.;
		UPDATE Mail_Mails SET ReadDate = mail_updatemail_readdate.readdate WHERE MailNo = mail_updatemail_readdate.mailno

	END

	ELSE BEGIN

		-- 태그별 메일 개수를 조정합니다.
		IF (TagNo != 0) BEGIN

			UPDATE Mail_MailTags SET UnReadCount = UnReadCount + 1 WHERE TagNo = TagNo

		END


		-- 현재, 전체 메일함의 메일 개수를 조정합니다.
		IF ((SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = BoxNo) > 0) BEGIN

			UPDATE Mail_MailBoxs SET UnReadCount = UnReadCount + 1
			WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_updatemail_readdate.userno AND ParentNo = -1 AND SortNo = 1)

		END

		UPDATE Mail_MailBoxs SET UnReadCount = UnReadCount + 1 WHERE BoxNo = BoxNo


		-- 메일 읽음 날짜를 변경합니다.;
		UPDATE Mail_Mails SET ReadDate = NULL WHERE MailNo = mail_updatemail_readdate.mailno

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
