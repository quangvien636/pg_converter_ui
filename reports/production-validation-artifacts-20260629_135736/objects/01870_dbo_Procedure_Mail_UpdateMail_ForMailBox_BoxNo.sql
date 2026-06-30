-- ─── PROCEDURE→FUNCTION: mail_updatemail_formailbox_boxno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_updatemail_formailbox_boxno(integer, bigint, bigint);
CREATE OR REPLACE FUNCTION public.mail_updatemail_formailbox_boxno(
    IN userno integer,
    IN beforeboxno bigint,
    IN afterboxno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    allboxs table (
		boxno	bigint
	);
    listofsendnums table (
			cmsendnum	bigint
		);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	INSERT INTO AllBoxs
	RETURN QUERY
	SELECT BoxNo FROM public."Mail_GetMailBoxs_ForAllBox"(UserNo)



	IF ((SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = mail_updatemail_formailbox_boxno.beforeboxno) > 0) SET IsBeforeBoxInAllBox = TRUE THEN
	ELSE SET IsBeforeBoxInAllBox = FALSE

	IF ((SELECT COUNT(*) FROM AllBoxs WHERE BoxNo = mail_updatemail_formailbox_boxno.afterboxno) > 0) SET IsAfterBoxInAllBox = TRUE THEN
	ELSE SET IsAfterBoxInAllBox = FALSE




	TotalCount := (COALESCE(COUNT(*), 0), UnReadCount = COALESCE(SUM(CASE WHEN ReadDate IS NULL THEN 1 ELSE 0 END), 0));
	FROM Mail_Mails WHERE BoxNo = mail_updatemail_formailbox_boxno.beforeboxno AND IsDelete = FALSE


	-- 현재, 전체 메일함의 메일 개수를 조정합니다.
	IF IsBeforeBoxInAllBox = TRUE AND IsAfterBoxInAllBox = FALSE THEN

		UPDATE Mail_MailBoxs SET TotalCount = TotalCount - TotalCount, UnReadCount = UnReadCount - UnReadCount
		WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_updatemail_formailbox_boxno.userno AND ParentNo = -1 AND SortNo = 1)

	END IF;

	ELSIF IsBeforeBoxInAllBox = FALSE AND IsAfterBoxInAllBox = TRUE THEN

		UPDATE Mail_MailBoxs SET TotalCount = TotalCount + TotalCount, UnReadCount = UnReadCount + UnReadCount
		WHERE BoxNo = (SELECT BoxNo FROM Mail_MailBoxs WHERE UserNo = mail_updatemail_formailbox_boxno.userno AND ParentNo = -1 AND SortNo = 1)

	END IF;

	UPDATE Mail_MailBoxs SET TotalCount = TotalCount - TotalCount, UnReadCount = UnReadCount - UnReadCount WHERE BoxNo = mail_updatemail_formailbox_boxno.beforeboxno;
	UPDATE Mail_MailBoxs SET TotalCount = TotalCount + TotalCount, UnReadCount = UnReadCount + UnReadCount WHERE BoxNo = mail_updatemail_formailbox_boxno.afterboxno


	-- 이동시킬 메일함이 휴지통일 경우 예약 메일을 취소합니다.

	SELECT ParentNo, SortNo INTO parentno, sortno FROM Mail_MailBoxs WHERE BoxNo = mail_updatemail_formailbox_boxno.afterboxno

	IF ParentNo = -1 AND SortNo = 6 THEN


		INSERT INTO ListOfSendNums
		RETURN QUERY
		SELECT CMSendNum FROM Mail_Mails
		WHERE BoxNo = mail_updatemail_formailbox_boxno.beforeboxno AND IsDelete = FALSE AND ReserveDate IS NOT NULL AND ReserveDate > NOW()
	
		UPDATE Mail_SentLogs SET IsCancel = TRUE WHERE CMSendNum IN (SELECT CMSendNum FROM ListOfSendNums);
		UPDATE CrewCloud_MailCenter.public."CMSend" SET RD = 'O' WHERE Num IN (SELECT CMSendNum FROM ListOfSendNums)

	END IF;


	-- 지정한 메일함으로 이동시킵니다.;
	UPDATE Mail_Mails SET BoxNo = mail_updatemail_formailbox_boxno.afterboxno WHERE BoxNo = mail_updatemail_formailbox_boxno.beforeboxno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
