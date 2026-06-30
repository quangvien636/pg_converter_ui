-- ─── PROCEDURE→FUNCTION: mail_cmsend_update_rd ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_cmsend_update_rd(bigint);
CREATE OR REPLACE FUNCTION public.mail_cmsend_update_rd(
    IN num bigint
) RETURNS void
AS $function$
BEGIN



	IF RD = 'O' THEN
	
		UPDATE Mail_SentLogs SET IsComplete = TRUE WHERE CMSendNum = mail_cmsend_update_rd.num AND IsCancel = FALSE
		

		
		SELECT MailNo, UserNo, BoxNo, IsDelete INTO mailno, userno, boxno, isdelete FROM Mail_Mails
		WHERE CMSendNum = mail_cmsend_update_rd.num AND IsSent = TRUE
		
		IF ReserveDate IS NOT NULL AND IsDelete = FALSE THEN
		

			CurrentlyBoxNo := (SELECT BoxNo FROM Mail_Mails WHERE MailNo = MailNo);
			SentMailBoxNo := (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = UserNo AND ParentNo = -1 AND SortNo = 3);;
			UPDATE Mail_Mails
			BoxNo := SentMailBoxNo, RegDate = NOW(), ReserveDate = NULL;
			WHERE MailNo = MailNo

			UPDATE Mail_MailBoxs SET TotalCount = TotalCount - 1 WHERE BoxNo = CurrentlyBoxNo;
			UPDATE Mail_MailBoxs SET TotalCount = TotalCount + 1 WHERE BoxNo = SentMailBoxNo
		
		END IF;

	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
