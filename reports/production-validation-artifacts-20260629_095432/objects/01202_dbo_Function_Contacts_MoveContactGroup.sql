-- ─── FUNCTION: contacts_movecontactgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_movecontactgroup(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_movecontactgroup(
    userno integer DEFAULT 70,
    groupno integer DEFAULT 644,
    newparentno integer DEFAULT 627,
    position integer DEFAULT 0
) RETURNS void
AS $function$
DECLARE
    sort integer;
    tempno integer;
BEGIN


SET Sort=0

SELECT  GroupNo from ContactsGroup WHERE RegUserNo=contacts_movecontactgroup.userno AND ParentGNo=contacts_movecontactgroup.newparentno AND UseYn='Y'  ORDER BY Sort ASC
OPEN Group_Cursor
FETCH NEXT FROM Group_Cursor 
INTO TEMPNO
WHILE @FETCH_STATUS = 0
   BEGIN
		RAISE NOTICE '%', TEMPNO
		IF (Sort<contacts_movecontactgroup.position)
		BEGIN
			RAISE NOTICE '%', Sort;
			UPDATE ContactsGroup SET Sort = Sort WHERE GroupNo=TEMPNO
		END
		IF(Sort=contacts_movecontactgroup.position)
		BEGIN
			RAISE NOTICE '%', Sort;
			UPDATE ContactsGroup SET Sort = Sort ,ParentGNo=contacts_movecontactgroup.newparentno WHERE GroupNo=contacts_movecontactgroup.groupno;
			UPDATE ContactsGroup SET Sort = Sort+1 WHERE GroupNo=TEMPNO
		END
		IF(Sort>contacts_movecontactgroup.position)
		BEGIN
			RAISE NOTICE '%', Sort;
			UPDATE ContactsGroup SET Sort = Sort+1 WHERE TEMPNO=contacts_movecontactgroup.groupno
		END
		SET Sort = Sort+1

		FETCH NEXT FROM Group_Cursor
		INTO  TEMPNO
   END;
CLOSE Group_Cursor;
DEALLOCATE Group_Cursor;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
