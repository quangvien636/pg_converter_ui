-- ─── FUNCTION: contacts_savesetup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_savesetup(integer, bigint, boolean);
CREATE OR REPLACE FUNCTION public.contacts_savesetup(
    pagesize integer,
    startcontactboxno bigint,
    isfolderexpanded boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	
	SELECT CNT = COUNT(UserNo) FROM ContactsSetup WHERE UserNo = UserNo
	
	IF CNT = 0
	BEGIN;
		INSERT INTO ContactsSetup
		(
			UserNo,
			RegUserNo,
			RegDate,
			ModUserNo,
			ModDate,
			PageSize,
			StartContactBoxNo,
			IsFolderExpanded
		)
		VALUES
		(
			UserNo,
			UserNo,
			NOW(),
			UserNo,
			NOW(),
			PageSize,
			StartContactBoxNo,
			IsFolderExpanded
		)
	END
	ELSE
	BEGIN
	
		UPDATE ContactsSetup
		SET
			ModUserNo = UserNo,
			ModDate = NOW(),
			PageSize = contacts_savesetup.pagesize,
			StartContactBoxNo = contacts_savesetup.startcontactboxno,
			IsFolderExpanded = contacts_savesetup.isfolderexpanded
		WHERE UserNo = UserNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
