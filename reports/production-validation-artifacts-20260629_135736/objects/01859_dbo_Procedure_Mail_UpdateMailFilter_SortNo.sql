-- ─── PROCEDURE→FUNCTION: mail_updatemailfilter_sortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_updatemailfilter_sortno(integer, bigint, integer);
CREATE OR REPLACE FUNCTION public.mail_updatemailfilter_sortno(
    IN userno integer,
    IN filterno bigint,
    IN updatetype integer
) RETURNS SETOF record
AS $function$
DECLARE
    maxsortord integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT SortNo INTO currentsortno FROM Mail_MailFilters WHERE FilterNo = mail_updatemailfilter_sortno.filterno
	
	IF (UpdateType = 1) BEGIN -- 위로 한단계 이동 THEN
	
		AfterSortNo := CurrentSortNo - 1;;
		UPDATE Mail_MailFilters SET SortNo = CurrentSortNo WHERE UserNo = mail_updatemailfilter_sortno.userno AND SortNo = AfterSortNo;
		UPDATE Mail_MailFilters SET SortNo = AfterSortNo WHERE FilterNo = mail_updatemailfilter_sortno.filterno
		
	END;
	
	ELSIF (UpdateType = 2) BEGIN -- 아래로 한단계 이동 THEN
		
		AfterSortNo := CurrentSortNo + 1;;
		UPDATE Mail_MailFilters SET SortNo = CurrentSortNo WHERE UserNo = mail_updatemailfilter_sortno.userno AND SortNo = AfterSortNo;
		UPDATE Mail_MailFilters SET SortNo = AfterSortNo WHERE FilterNo = mail_updatemailfilter_sortno.filterno
		
	END;
	
	ELSIF (UpdateType = 3) BEGIN -- 맨 위로 이동 THEN
	
		UPDATE Mail_MailFilters SET SortNo = SortNo + 1 WHERE UserNo = mail_updatemailfilter_sortno.userno AND SortNo < CurrentSortNo;
		UPDATE Mail_MailFilters SET SortNo = 1 WHERE FilterNo = mail_updatemailfilter_sortno.filterno
	
	END;
	
	ELSIF (UpdateType = 4) BEGIN -- 맨 아래로 이동 THEN
		

		SELECT MAX(SortNo) INTO maxsortord FROM Mail_MailFilters WHERE UserNo = mail_updatemailfilter_sortno.userno
	
		UPDATE Mail_MailFilters SET SortNo = SortNo - 1 WHERE UserNo = mail_updatemailfilter_sortno.userno AND SortNo > CurrentSortNo;
		UPDATE Mail_MailFilters SET SortNo = MaxSortOrd WHERE FilterNo = mail_updatemailfilter_sortno.filterno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
