-- ─── FUNCTION: mail_deletemailbox ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deletemailbox(integer, bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemailbox(
    userno integer,
    boxno bigint
) RETURNS TABLE(
    cmsendnum text
)
AS $function$
DECLARE
    allboxs table (
		boxno	bigint
	);
    listofsendnums table (
		cmsendnum bigint
	);
BEGIN

	


	SELECT TotalCount = TotalCount, UnReadCount = UnReadCount FROM Mail_MailBoxs WHERE BoxNo = mail_deletemailbox.boxno
	SELECT TrashBoxNo = mail_deletemailbox.boxno FROM Mail_MailBoxs WHERE UserNo = mail_deletemailbox.userno AND ParentNo = -1 AND SortNo = 6


	-- 전체 메일함의 메일 개수를 조정합니다.

	INSERT INTO AllBoxs
	RETURN QUERY
	SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo)

	IF ((SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = mail_deletemailbox.boxno) > 0) BEGIN

		UPDATE Mail_MailBoxs SET TotalCount = TotalCount - TotalCount, UnReadCount = UnReadCount - UnReadCount
		WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_deletemailbox.userno AND ParentNo = -1 AND SortNo = 1)

	END


	-- 예약 메일을 모두 취소합니다.

	INSERT INTO ListOfSendNums
	RETURN QUERY
	SELECT CMSendNum FROM Mail_Mails WHERE BoxNo = mail_deletemailbox.boxno AND IsDelete = FALSE AND ReserveDate IS NOT NULL AND ReserveDate > NOW()

	UPDATE Mail_SentLogs SET IsCancel = TRUE WHERE CMSendNum IN (SELECT CMSendNum FROM ListOfSendNums);
	UPDATE CrewCloud_MailCenter.public."CMSend" SET RD = 'O' WHERE Num IN (SELECT CMSendNum FROM ListOfSendNums)


	-- 삭제할 메일함의 메일들을 휴지통으로 이동합니다.;
	UPDATE Mail_Mails SET BoxNo = TrashBoxNo WHERE BoxNo = mail_deletemailbox.boxno;
	UPDATE Mail_MailBoxs SET TotalCount = TotalCount + TotalCount, UnReadCount = UnReadCount + UnReadCount WHERE BoxNo = TrashBoxNo
	

	-- 메일함을 삭제합니다.;
	DELETE FROM Mail_MailBoxs WHERE BoxNo = mail_deletemailbox.boxno


	-- 메일 분류 정보를 삭제합니다.;
	DELETE FROM Mail_MailFilters WHERE MailBoxNo = mail_deletemailbox.boxno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
