-- ─── FUNCTION: contacts_savegroupforoutlook ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_savegroupforoutlook(character varying);
CREATE OR REPLACE FUNCTION public.contacts_savegroupforoutlook(
    outlookentryid character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    groupno integer;
    groupcount integer;
BEGIN



	SELECT GroupCount = COUNT(GroupNo)
	FROM ContactsGroupOutlook
	WHERE UserNo = UserNo
	AND OutlookFolderEntryID = contacts_savegroupforoutlook.outlookentryid
	
	IF GroupCount = 0
	BEGIN;
		INSERT INTO ContactsGroup
		(
			RegDate,
			RegUserNo,
			ParentGNo,
			GroupName,
			IsDefault,
			Memo,
			Sort
		)
		VALUES
		(
			NOW(),
			UserNo,
			0,
			GroupName,
			1,
			'아웃룩',
			(SELECT COALESCE(MAX(Sort),0)+1 FROM ContactsGroup WHERE RegUserNo = UserNo)
		)
		
		SET GroupNo  = lastval()
		
		INSERT INTO ContactsGroupOutlook
		(
			UserNo,
			GroupNo,
			OutlookFolderEntryID
		)
		VALUES
		(
			UserNo,
			GroupNo,
			OutlookEntryID
		)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
