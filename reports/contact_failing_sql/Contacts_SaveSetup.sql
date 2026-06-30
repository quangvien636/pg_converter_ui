-- ─── PROCEDURE→FUNCTION: contacts_savesetup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_savesetup(integer, integer, bigint, boolean);
CREATE OR REPLACE FUNCTION public.contacts_savesetup(
    IN userno integer,
    IN pagesize integer,
    IN startcontactboxno bigint,
    IN isfolderexpanded boolean
) RETURNS SETOF record
AS $function$
DECLARE
    cnt integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT COUNT(UserNo) INTO cnt FROM ContactsSetup WHERE UserNo = contacts_savesetup.userno

	IF CNT = 0 THEN
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
		);
	ELSE

		UPDATE ContactsSetup
		SET
			ModUserNo = contacts_savesetup.userno,
			ModDate = NOW(),
			PageSize = contacts_savesetup.pagesize,
			StartContactBoxNo = contacts_savesetup.startcontactboxno,
			IsFolderExpanded = contacts_savesetup.isfolderexpanded
		WHERE UserNo = contacts_savesetup.userno;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.