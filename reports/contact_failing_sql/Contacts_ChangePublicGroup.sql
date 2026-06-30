-- ─── PROCEDURE→FUNCTION: contacts_changepublicgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_changepublicgroup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_changepublicgroup(
    IN groupno integer DEFAULT 8,
    IN userseqlist character varying DEFAULT '8164',
    IN userno integer DEFAULT 70
) RETURNS SETOF record
AS $function$
DECLARE
    userseq integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

IF GroupNo=0 THEN
	UPDATE Contact_PublicGroupUser SET IsDelete = TRUE WHERE UserSeq IN (SELECT * FROM fnStringtoListInt(UserSeqList));
ELSE




		FOR userseq IN SELECT * FROM fnStringtoListInt(UserSeqList) LOOP
    --Do something with Id here

		IF (SELECT COUNT(*) FROM Contact_PublicGroupUser WHERE UserSeq= UserSeq AND PublicGroupNo=contacts_changepublicgroup.groupno)>0 THEN
			UPDATE Contact_PublicGroupUser SET PublicGroupNo = contacts_changepublicgroup.groupno ,ModDate=NOW(),ModUserNo=contacts_changepublicgroup.userno WHERE PublicGroupNo=contacts_changepublicgroup.groupno AND UserSeq =UserSeq;
		ELSE
			INSERT INTO Contact_PublicGroupUser(PublicGroupNo,UserSeq,RegUserNo,RegDate,ModUserNo,ModDate,IsDelete) VALUES(GroupNo,UserSeq,UserNo,NOW(),UserNo,NOW(),'FALSE');
		END IF;
    --PRINT UserSeq;
			END LOOP
	END IF;
	--UPDATE Contacts_ChangeGroup SET ShareGroupNo = GroupNo WHERE ShareGroupNo=GroupNo AND UserSeq IN (SELECT * FROM fnStringtoListInt(UserSeqList))

END;

--SELECT COUNT(*) FROM Contact_PublicGroupUser WHERE UserSeq= 8164 AND PublicGroupNo=8
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.