-- ─── FUNCTION: contacts_insertcontactforoutlookfolderentryid ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_insertcontactforoutlookfolderentryid(integer);
CREATE OR REPLACE FUNCTION public.contacts_insertcontactforoutlookfolderentryid(
    groupno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	
	SELECT EntryCount = COUNT(GroupNo) 
	FROM ContactsGroupOutlook
	WHERE OutlookFolderEntryID = FolderEntryID
	
	IF EntryCount = 0
	BEGIN;
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
			FolderEntryID
		)
	END
	ELSE
	BEGIN;
		UPDATE ContactsGroupOutlook
		SET
			OutlookFolderEntryID = FolderEntryID
		WHERE UserNo = UserNo
		AND GroupNo = contacts_insertcontactforoutlookfolderentryid.groupno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
