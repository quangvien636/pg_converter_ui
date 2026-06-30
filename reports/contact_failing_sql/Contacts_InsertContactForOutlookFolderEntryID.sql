-- ─── PROCEDURE→FUNCTION: contacts_insertcontactforoutlookfolderentryid ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_insertcontactforoutlookfolderentryid(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_insertcontactforoutlookfolderentryid(
    IN userno integer,
    IN groupno integer
) RETURNS SETOF record
AS $function$
DECLARE
    entrycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT  INTO  FROM ContactsGroupOutlook
	WHERE OutlookFolderEntryID = FolderEntryID

	IF EntryCount = 0 THEN
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
		);
	ELSE
		UPDATE ContactsGroupOutlook
		SET
			OutlookFolderEntryID = FolderEntryID
		WHERE UserNo = contacts_insertcontactforoutlookfolderentryid.userno
		AND GroupNo = contacts_insertcontactforoutlookfolderentryid.groupno;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.