-- ─── FUNCTION: mail_cmsend_update_rd ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_cmsend_update_rd(bigint);
CREATE OR REPLACE FUNCTION public.mail_cmsend_update_rd(
    num bigint
) RETURNS void
AS $function$
BEGIN




	IF (RD = 'O') BEGIN
	
		UPDATE Mail_SentLogs SET IsComplete = TRUE WHERE CMSendNum = mail_cmsend_update_rd.num AND IsCancel = FALSE
		

		
		SELECT MailNo = MailNo, UserNo = UserNo, BoxNo = BoxNo, IsDelete = IsDelete, ReserveDate = ReserveDate
		FROM Mail_Mails
		WHERE CMSendNum = mail_cmsend_update_rd.num AND IsSent = TRUE
		
		IF (ReserveDate IS NOT NULL AND IsDelete = FALSE) BEGIN
		

			SET CurrentlyBoxNo = (SELECT BoxNo FROM Mail_Mails WHERE MailNo = MailNo)
			SET SentMailBoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = UserNo AND ParentNo = -1 AND SortNo = 3)

			UPDATE Mail_Mails
			SET BoxNo = SentMailBoxNo, RegDate = NOW(), ReserveDate = NULL
			WHERE MailNo = MailNo

			UPDATE Mail_MailBoxs SET TotalCount = TotalCount - 1 WHERE BoxNo = CurrentlyBoxNo;
			UPDATE Mail_MailBoxs SET TotalCount = TotalCount + 1 WHERE BoxNo = SentMailBoxNo
		
		END

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
