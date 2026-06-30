-- ─── FUNCTION: contacts_insertcontactforoutlookentryid ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_insertcontactforoutlookentryid(integer);
CREATE OR REPLACE FUNCTION public.contacts_insertcontactforoutlookentryid(
    seq integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	
	SELECT EntryCount = COUNT(Seq) 
	FROM ContactsUserOutlook
	WHERE OutlookEntryID = OutlookEntryID
	
	IF EntryCount = 0
	BEGIN;
		INSERT INTO ContactsUserOutlook
		(
			UserNo,
			Seq,
			OutlookEntryID
		)
		VALUES
		(
			UserNo,
			Seq,
			OutlookEntryID
		)
	END
	ELSE
	BEGIN;
		UPDATE ContactsUserOutlook
		SET
			OutlookEntryID = OutlookEntryID
		WHERE UserNo = UserNo
		AND Seq = contacts_insertcontactforoutlookentryid.seq
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
