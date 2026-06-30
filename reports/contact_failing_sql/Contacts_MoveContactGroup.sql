-- ─── PROCEDURE→FUNCTION: contacts_movecontactgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_movecontactgroup(integer, integer, integer, "position" integer);
CREATE OR REPLACE FUNCTION public.contacts_movecontactgroup(
    IN userno integer DEFAULT 70,
    IN groupno integer DEFAULT 644,
    IN newparentno integer DEFAULT 627,
    IN "position" integer DEFAULT 0
) RETURNS void
AS $function$
DECLARE
    sort integer;
    tempno integer;
BEGIN


Sort := 0;
FOR tempno IN SELECT  GroupNo from ContactsGroup WHERE RegUserNo=contacts_movecontactgroup.userno AND ParentGNo=contacts_movecontactgroup.newparentno AND UseYn='Y'  ORDER BY Sort ASC LOOP
		RAISE NOTICE '%', TEMPNO
		IF Sort<Position THEN
			RAISE NOTICE '%', Sort;
			UPDATE ContactsGroup SET Sort = Sort WHERE GroupNo=TEMPNO;
		END IF;
		IF Sort=Position THEN
			RAISE NOTICE '%', Sort;
			UPDATE ContactsGroup SET Sort = Sort ,ParentGNo=contacts_movecontactgroup.newparentno WHERE GroupNo=contacts_movecontactgroup.groupno;
			UPDATE ContactsGroup SET Sort = Sort+1 WHERE GroupNo=TEMPNO;
		END IF;
		IF Sort>Position THEN
			RAISE NOTICE '%', Sort;
			UPDATE ContactsGroup SET Sort = Sort+1 WHERE TEMPNO=contacts_movecontactgroup.groupno;
		END IF;
		Sort := Sort+1;
		   END LOOP;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.