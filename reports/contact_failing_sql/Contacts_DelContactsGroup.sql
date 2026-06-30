-- ─── PROCEDURE→FUNCTION: contacts_delcontactsgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: TRY/CATCH requires manual EXCEPTION block review
DROP FUNCTION IF EXISTS public.contacts_delcontactsgroup(integer);
CREATE OR REPLACE FUNCTION public.contacts_delcontactsgroup(
    IN groupno integer
) RETURNS void
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	--BEGIN TRY
		--BEGIN TRAN
		--DELETE FROM ContactsGroupUser WHERE GroupNo = GroupNo
		--DELETE FROM ContactsGroup WHERE GroupNo = GroupNo
		CREATE TEMP TABLE temp(GroupNo int);
		WITH RECURSIVE GroupTmp AS (
			SELECT  G.*
			FROM  ContactsGroup G
			WHERE G.GroupNo= contacts_delcontactsgroup.groupno
			UNION ALL
			SELECT  GC.*
			FROM ContactsGroup GC
			INNER JOIN GroupTmp GT ON GC.ParentGNo=GT.GroupNo
		)
		INSERT INTO temp
		SELECT GroupNo FROM GroupTmp;
		UPDATE ContactsGroup SET UseYn='' WHERE GroupNo IN (SELECT GroupNo FROM temp);
		UPDATE ContactsUser SET UseYn='F', DelDate=NOW() WHERE Seq IN (SELECT UserSeq FROM ContactsGroupUser U INNER JOIN temp GU ON GU.GroupNo=U.GroupNo);
		DELETE FROM ContactsGroupUser  WHERE Seq IN (SELECT GroupNo FROM  temp);
		Drop Table Temp
		--COMMIT TRAN
	--END TRY
	--BEGIN CATCH
		--ROLLBACK TRAN
	--END CATCH

	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.