-- ─── FUNCTION: mail_updatemail_formailbox_readdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemail_formailbox_readdate(integer, bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_updatemail_formailbox_readdate(
    userno integer,
    boxno bigint,
    readdate timestamp without time zone
) RETURNS void
AS $function$
DECLARE
    countofunreadmails integer;
    listoftags table (
		tagno		bigint,
		unreadcount	int
	);
    allboxs table (
		boxno	bigint
	);
    unreadcount integer;
    mailcount integer;
BEGIN



	SET CountOfUnReadMails = (SELECT UnReadCount FROM Mail_MailBoxs WHERE BoxNo = mail_updatemail_formailbox_readdate.boxno)
	

	INSERT INTO ListOfTags
	SELECT TagNo, SUM(CASE WHEN ReadDate IS NULL THEN 1 ELSE 0 END) AS UnReadCount
	FROM Mail_Mails
	WHERE BoxNo = mail_updatemail_formailbox_readdate.boxno AND IsDelete = FALSE AND TagNo != 0 
	GROUP BY TagNo


	INSERT INTO AllBoxs
	SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo)


	SET UnReadCount = (SELECT UnReadCount FROM Mail_MailBoxs WHERE BoxNo = mail_updatemail_formailbox_readdate.boxno)


	IF (ReadDate IS NOT NULL) BEGIN

		-- 태그별 메일 개수를 조정합니다.;
		UPDATE Mail_MailTags
		SET UnReadCount = UnReadCount - (SELECT UnReadCount FROM ListOfTags WHERE TagNo = Mail_MailTags.TagNo)
		WHERE TagNo IN (SELECT TagNo FROM ListOfTags)


		-- 현재, 전체 메일함의 메일 개수를 조정합니다.
		IF ((SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = mail_updatemail_formailbox_readdate.boxno) > 0) BEGIN

			UPDATE Mail_MailBoxs SET UnReadCount = UnReadCount - UnReadCount
			WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_updatemail_formailbox_readdate.userno AND ParentNo = -1 AND SortNo = 1)

		END

		UPDATE Mail_MailBoxs SET UnReadCount = 0 WHERE BoxNo = mail_updatemail_formailbox_readdate.boxno


		-- 메일 읽음 날짜를 변경합니다.;
		UPDATE Mail_Mails SET ReadDate = mail_updatemail_formailbox_readdate.readdate WHERE BoxNo = mail_updatemail_formailbox_readdate.boxno AND IsDelete = FALSE

	END

	ELSE BEGIN


		SET MailCount = (SELECT COUNT(*) FROM Mail_Mails WHERE BoxNo = mail_updatemail_formailbox_readdate.boxno AND IsDelete = FALSE)


		-- 태그별 메일 개수를 조정합니다.;
		UPDATE Mail_MailTags
		SET UnReadCount = UnReadCount - (SELECT UnReadCount FROM ListOfTags WHERE TagNo = Mail_MailTags.TagNo) + MailCount
		WHERE TagNo IN (SELECT TagNo FROM ListOfTags)


		-- 현재, 전체 메일함의 메일 개수를 조정합니다.
		IF ((SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = mail_updatemail_formailbox_readdate.boxno) > 0) BEGIN

			UPDATE Mail_MailBoxs SET UnReadCount = UnReadCount - UnReadCount + MailCount
			WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_updatemail_formailbox_readdate.userno AND ParentNo = -1 AND SortNo = 1)

		END

		UPDATE Mail_MailBoxs SET UnReadCount = MailCount WHERE BoxNo = mail_updatemail_formailbox_readdate.boxno


		-- 메일 읽음 날짜를 변경합니다.;
		UPDATE Mail_Mails SET ReadDate = NULL WHERE BoxNo = mail_updatemail_formailbox_readdate.boxno AND IsDelete = FALSE

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
