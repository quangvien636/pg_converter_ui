-- ─── PROCEDURE→FUNCTION: contacts_delallcontactstrash ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_delallcontactstrash(integer);
CREATE OR REPLACE FUNCTION public.contacts_delallcontactstrash(
    IN reguserno integer
) RETURNS void
AS $function$
BEGIN

	--DELETE FROM ContactsNumber WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsEmail WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsDays WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsCompany WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsAddress WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsSns WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsGroupUser WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '';
	UPDATE ContactsUser SET UseYn='F' WHERE RegUserNo = contacts_delallcontactstrash.reguserno AND UseYn = '';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
