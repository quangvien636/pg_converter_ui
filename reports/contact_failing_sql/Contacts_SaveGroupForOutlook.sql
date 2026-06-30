-- ─── PROCEDURE→FUNCTION: contacts_savegroupforoutlook ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_savegroupforoutlook(integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_savegroupforoutlook(
    IN userno integer,
    IN outlookentryid character varying
) RETURNS SETOF record
AS $function$
DECLARE
    groupno integer;
    groupcount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SELECT  INTO  FROM ContactsGroupOutlook
	WHERE UserNo = contacts_savegroupforoutlook.userno
	AND OutlookFolderEntryID = contacts_savegroupforoutlook.outlookentryid;

	IF GroupCount = 0 THEN
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
			(SELECT COALESCE(MAX(Sort),0)+1 FROM ContactsGroup WHERE RegUserNo = contacts_savegroupforoutlook.userno)
		);

		GroupNo := lastval();
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
		);
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.