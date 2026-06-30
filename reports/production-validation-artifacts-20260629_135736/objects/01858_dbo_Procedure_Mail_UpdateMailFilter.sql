-- ─── PROCEDURE→FUNCTION: mail_updatemailfilter ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_updatemailfilter(integer, bigint, character varying, character varying, character varying, character varying, bigint);
CREATE OR REPLACE FUNCTION public.mail_updatemailfilter(
    IN userno integer,
    IN filterno bigint,
    IN fieldtype character varying,
    IN conditiontype character varying,
    IN executetype character varying,
    IN executevalue character varying,
    IN mailboxno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    _filterno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	 * 같은 규칙이 있으면 삭제합니다.
	 */
	 

	SELECT FilterNo INTO _filterno FROM Mail_MailFilters
	WHERE UserNo = mail_updatemailfilter.userno AND FieldFg = mail_updatemailfilter.fieldtype AND ConditionType = ConditionFg AND ExecValue = mail_updatemailfilter.executevalue

	IF _FilterNo IS NOT NULL THEN
	
		PERFORM mail_deletemailfilter(_FilterNo
		
		EXEC Mail_InsertMailFilter UserNo, FieldType, ConditionType, ExecuteType, ExecuteValue, MailBoxNo, 0
	
	END IF;
	
	ELSE BEGIN
	
		UPDATE Mail_MailFilters SET
			FieldType,
			ConditionType,
			ExecuteType,
			ExecuteValue,
			MailBoxNo
		WHERE FilterNo
	
	END);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
