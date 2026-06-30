-- ─── FUNCTION: contacts_deletehistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_deletehistory();
CREATE OR REPLACE FUNCTION public.contacts_deletehistory(
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    temphistoryno integer;
    chkhistoryno character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SET HistoryNoList = HistoryNoList || ','
	SET ChkHistoryNo = REPLACE(HistoryNoList,',','')
	IF LEN(ChkHistoryNo) > 0
	BEGIN
		BEGIN TRAN
		WHILE STRPOS(',HistoryNoList, ') > 0
		BEGIN
			SET TempHistoryNo = SUBSTRING(HistoryNoList,0,STRPOS(',HistoryNoList, '))
			
			DELETE FROM ContactsNumberHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsEmailHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsDaysHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsCompanyHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsAddressHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsSnsHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsGroupUserHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsUserHistory WHERE HistoryNo = TempHistoryNo
			
			SET HistoryNoList = SUBSTRING(HistoryNoList,STRPOS(',HistoryNoList, ')+1,LEN(HistoryNoList))
		END	
		
		IF @ERROR <> 0
		BEGIN
			ROLLBACK TRAN
		END
		COMMIT TRAN
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
