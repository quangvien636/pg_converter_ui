-- ─── PROCEDURE→FUNCTION: contacts_setcontactsgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_setcontactsgroup(integer, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setcontactsgroup(
    IN groupno integer,
    IN groupname character varying,
    IN reguserno integer,
    IN memo character varying
) RETURNS SETOF record
AS $function$
DECLARE
    sort integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = '0' THEN

		SELECT COUNT(*) + 1 INTO sort FROM ContactsGroup WHERE RegUserNo=contacts_setcontactsgroup.reguserno AND ParentGNo=contacts_setcontactsgroup.groupno
	
		INSERT INTO ContactsGroup(GroupName, RegUserNo, RegDate, Memo,ParentGNo,Sort, IsDefault)
		VALUES(GroupName, RegUserNo, NOW(), Memo, GroupNo, Sort , '0')
	END IF;
	ELSIF Mode = '1' THEN;
		UPDATE ContactsGroup SET GroupName=contacts_setcontactsgroup.groupname WHERE GroupNo=contacts_setcontactsgroup.groupno
	END IF;
	ELSE;
		UPDATE ContactsGroup SET Memo=contacts_setcontactsgroup.memo WHERE GroupNo=contacts_setcontactsgroup.groupno
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
