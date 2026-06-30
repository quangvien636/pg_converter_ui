-- ─── PROCEDURE→FUNCTION: contacts_changesharegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_changesharegroup(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_changesharegroup(
    IN userno integer,
    IN groupno integer DEFAULT 689,
    IN userseqlist character varying DEFAULT '7996,7995'
) RETURNS void
AS $function$
DECLARE
    userseq integer;
    my_cursor cursor;
BEGIN

IF(GroupNo=0)
BEGIN;
	UPDATE Contact_ShareGroupUser SET IsDelete = TRUE WHERE UserSeq IN (SELECT * FROM fnStringtoListInt(UserSeqList))
END;
ELSE


	LOCAL STATIC READ_ONLY FORWARD_ONLY
	FOR 
	SELECT * FROM fnStringtoListInt(UserSeqList)

	OPEN MY_CURSOR
	FETCH NEXT FROM MY_CURSOR INTO UserSeq
	WHILE @FETCH_STATUS = 0
	BEGIN 
    --Do something with Id here

		IF(SELECT COUNT(*) FROM Contact_ShareGroupUser WHERE UserSeq= UserSeq AND ShareGroupNo=contacts_changesharegroup.groupno)>0
		BEGIN;
			UPDATE Contact_ShareGroupUser SET ShareGroupNo = contacts_changesharegroup.groupno ,ModDate=NOW(),ModUserNo=contacts_changesharegroup.userno WHERE ShareGroupNo=contacts_changesharegroup.groupno AND UserSeq =UserSeq
		END;
		ELSE;
			INSERT INTO Contact_ShareGroupUser(ShareGroupNo,UserSeq,RegUserNo,RegDate,ModUserNo,ModDate,IsDelete) VALUES(GroupNo,UserSeq,UserNo,NOW(),UserNo,NOW(),'FALSE')
		END IF;
		FETCH NEXT FROM MY_CURSOR INTO UserSeq
	END;
	CLOSE MY_CURSOR
	DEALLOCATE MY_CURSOR
END IF;
	--UPDATE Contacts_ChangeGroup SET ShareGroupNo = GroupNo WHERE ShareGroupNo=GroupNo AND UserSeq IN (SELECT * FROM fnStringtoListInt(UserSeqList))
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
