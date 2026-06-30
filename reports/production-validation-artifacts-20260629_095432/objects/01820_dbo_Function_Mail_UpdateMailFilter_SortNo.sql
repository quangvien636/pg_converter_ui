-- ─── FUNCTION: mail_updatemailfilter_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailfilter_sortno(integer, bigint, integer);
CREATE OR REPLACE FUNCTION public.mail_updatemailfilter_sortno(
    userno integer,
    filterno bigint,
    updatetype integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    maxsortord integer;
BEGIN



	SELECT CurrentSortNo = SortNo FROM Mail_MailFilters WHERE FilterNo = mail_updatemailfilter_sortno.filterno
	
	IF (UpdateType = 1) BEGIN -- 위로 한단계 이동
	
		SET AfterSortNo = CurrentSortNo - 1
		
		UPDATE Mail_MailFilters SET SortNo = CurrentSortNo WHERE UserNo = mail_updatemailfilter_sortno.userno AND SortNo = AfterSortNo;
		UPDATE Mail_MailFilters SET SortNo = AfterSortNo WHERE FilterNo = mail_updatemailfilter_sortno.filterno
		
	END
	
	ELSE IF (UpdateType = 2) BEGIN -- 아래로 한단계 이동
		
		SET AfterSortNo = CurrentSortNo + 1
		
		UPDATE Mail_MailFilters SET SortNo = CurrentSortNo WHERE UserNo = mail_updatemailfilter_sortno.userno AND SortNo = AfterSortNo;
		UPDATE Mail_MailFilters SET SortNo = AfterSortNo WHERE FilterNo = mail_updatemailfilter_sortno.filterno
		
	END
	
	ELSE IF (UpdateType = 3) BEGIN -- 맨 위로 이동
	
		UPDATE Mail_MailFilters SET SortNo = SortNo + 1 WHERE UserNo = mail_updatemailfilter_sortno.userno AND SortNo < CurrentSortNo;
		UPDATE Mail_MailFilters SET SortNo = 1 WHERE FilterNo = mail_updatemailfilter_sortno.filterno
	
	END
	
	ELSE IF (UpdateType = 4) BEGIN -- 맨 아래로 이동
		

		SELECT MaxSortOrd = MAX(SortNo) FROM Mail_MailFilters WHERE UserNo = mail_updatemailfilter_sortno.userno
	
		UPDATE Mail_MailFilters SET SortNo = SortNo - 1 WHERE UserNo = mail_updatemailfilter_sortno.userno AND SortNo > CurrentSortNo;
		UPDATE Mail_MailFilters SET SortNo = MaxSortOrd WHERE FilterNo = mail_updatemailfilter_sortno.filterno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
