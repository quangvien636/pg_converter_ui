-- ─── PROCEDURE→FUNCTION: mail_updatemail_readdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_updatemail_readdate(integer, bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_updatemail_readdate(
    IN userno integer,
    IN mailno bigint,
    IN readdate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    allboxs table (
		boxno	bigint
	);
    mailaddress character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	
	SELECT CMSendNum, BoxNo, AccNo, TagNo, ReadDate INTO cmsendnum, boxno, accno, tagno, _readdate FROM Mail_Mails WHERE MailNo = mail_updatemail_readdate.mailno
	
	IF _ReadDate IS NULL AND ReadDate IS NULL THEN

		RETURN

	END IF;

	IF _ReadDate IS NOT NULL AND ReadDate IS NOT NULL THEN

		RETURN

	END IF;

	IF IsDelete = TRUE THEN

		RETURN

	END IF;



	INSERT INTO AllBoxs
	RETURN QUERY
	SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo)



	IF ReadDate IS NOT NULL THEN

		-- 태그별 메일 개수를 조정합니다.
		IF TagNo != 0 THEN

			UPDATE Mail_MailTags SET UnReadCount = UnReadCount - 1 WHERE TagNo = TagNo

		END IF;


		-- 현재, 전체 메일함의 메일 개수를 조정합니다.
		IF (SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = BoxNo) > 0 THEN

			UPDATE Mail_MailBoxs SET UnReadCount = UnReadCount - 1
			WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_updatemail_readdate.userno AND ParentNo = -1 AND SortNo = 1)

		END IF;

		UPDATE Mail_MailBoxs SET UnReadCount = UnReadCount - 1 WHERE BoxNo = BoxNo


		-- 수신 이력를 추가합니다.
		IF CMSendNum != 0 THEN
	

			SELECT MailAddress INTO mailaddress FROM Mail_Accounts WHERE AccountNo = AccNo
	
			EXEC Mail_UpdateSentLog_ReadDate CMSendNum, MailAddress, 0
			
		END IF;


		-- 메일 읽음 날짜를 변경합니다.;
		UPDATE Mail_Mails SET ReadDate = mail_updatemail_readdate.readdate WHERE MailNo = mail_updatemail_readdate.mailno

	END IF;

	ELSE BEGIN

		-- 태그별 메일 개수를 조정합니다.
		IF TagNo != 0 THEN

			UPDATE Mail_MailTags SET UnReadCount = UnReadCount + 1 WHERE TagNo = TagNo

		END IF;


		-- 현재, 전체 메일함의 메일 개수를 조정합니다.
		IF (SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = BoxNo) > 0 THEN

			UPDATE Mail_MailBoxs SET UnReadCount = UnReadCount + 1
			WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_updatemail_readdate.userno AND ParentNo = -1 AND SortNo = 1)

		END IF;

		UPDATE Mail_MailBoxs SET UnReadCount = UnReadCount + 1 WHERE BoxNo = BoxNo


		-- 메일 읽음 날짜를 변경합니다.;
		UPDATE Mail_Mails SET ReadDate = NULL WHERE MailNo = mail_updatemail_readdate.mailno

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
