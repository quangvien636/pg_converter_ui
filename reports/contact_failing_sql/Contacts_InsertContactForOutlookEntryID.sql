-- ─── PROCEDURE→FUNCTION: contacts_insertcontactforoutlookentryid ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_insertcontactforoutlookentryid(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_insertcontactforoutlookentryid(
    IN userno integer,
    IN seq integer
) RETURNS SETOF record
AS $function$
DECLARE
    entrycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT  INTO  FROM ContactsUserOutlook
	WHERE OutlookEntryID = OutlookEntryID;

	IF EntryCount = 0 THEN
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
		);
	ELSE
		UPDATE ContactsUserOutlook
		SET
			OutlookEntryID = OutlookEntryID
		WHERE UserNo = contacts_insertcontactforoutlookentryid.userno
		AND Seq = contacts_insertcontactforoutlookentryid.seq;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.