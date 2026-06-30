-- ─── PROCEDURE→FUNCTION: contacts_deletehistory ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_deletehistory();
CREATE OR REPLACE FUNCTION public.contacts_deletehistory(
) RETURNS void
AS $function$
DECLARE
    temphistoryno integer;
    chkhistoryno character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	HistoryNoList := HistoryNoList || ',';
	ChkHistoryNo := REPLACE(HistoryNoList,',','');
	IF LEN(ChkHistoryNo) > 0 THEN

		WHILE STRPOS(',HistoryNoList, ') > 0 LOOP
			TempHistoryNo := SUBSTRING(HistoryNoList,0,STRPOS(',HistoryNoList, '));
			DELETE FROM ContactsNumberHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsEmailHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsDaysHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsCompanyHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsAddressHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsSnsHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsGroupUserHistory WHERE HistoryNo = TempHistoryNo;
			DELETE FROM ContactsUserHistory WHERE HistoryNo = TempHistoryNo;

			HistoryNoList := SUBSTRING(HistoryNoList,STRPOS(',HistoryNoList, ')+1,LEN(HistoryNoList));
		END LOOP;

		IF @ERROR <> 0 THEN

		END IF;

	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.