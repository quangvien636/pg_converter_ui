-- ─── FUNCTION: mail_updatemailfilter ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailfilter(integer, bigint, character varying, character varying, character varying, character varying, bigint);
CREATE OR REPLACE FUNCTION public.mail_updatemailfilter(
    userno integer,
    filterno bigint,
    fieldtype character varying,
    conditiontype character varying,
    executetype character varying,
    executevalue character varying,
    mailboxno bigint
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    _filterno bigint;
BEGIN


	/*
	 * 같은 규칙이 있으면 삭제합니다.
	 */
	 

	SELECT _FilterNo = mail_updatemailfilter.filterno FROM Mail_MailFilters
	WHERE UserNo = mail_updatemailfilter.userno AND FieldFg = mail_updatemailfilter.fieldtype AND ConditionType = ConditionFg AND ExecValue = mail_updatemailfilter.executevalue

	IF (_FilterNo IS NOT NULL) BEGIN
	
		EXEC Mail_DeleteMailFilter _FilterNo
		
		EXEC Mail_InsertMailFilter UserNo, FieldType, ConditionType, ExecuteType, ExecuteValue, MailBoxNo, 0
	
	END
	
	ELSE BEGIN
	
		UPDATE Mail_MailFilters SET
			FieldFg = mail_updatemailfilter.fieldtype,
			ConditionFg = mail_updatemailfilter.conditiontype,
			ExecFg = mail_updatemailfilter.executetype,
			ExecValue = mail_updatemailfilter.executevalue,
			MailBoxNo = mail_updatemailfilter.mailboxno
		WHERE FilterNo = mail_updatemailfilter.filterno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
