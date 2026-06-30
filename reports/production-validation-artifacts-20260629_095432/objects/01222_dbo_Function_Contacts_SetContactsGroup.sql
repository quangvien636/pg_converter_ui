-- ─── FUNCTION: contacts_setcontactsgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setcontactsgroup(integer, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setcontactsgroup(
    groupno integer,
    groupname character varying,
    reguserno integer,
    memo character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    sort integer;
BEGIN

	IF Mode = '0'
	BEGIN

		SELECT Sort = COUNT(*) + 1 FROM ContactsGroup WHERE RegUserNo=contacts_setcontactsgroup.reguserno AND ParentGNo=contacts_setcontactsgroup.groupno
	
		INSERT INTO ContactsGroup(GroupName, RegUserNo, RegDate, Memo,ParentGNo,Sort, IsDefault)
		VALUES(GroupName, RegUserNo, NOW(), Memo, GroupNo, Sort , '0')
	END
	ELSE IF Mode = '1'
	BEGIN;
		UPDATE ContactsGroup SET GroupName=contacts_setcontactsgroup.groupname WHERE GroupNo=contacts_setcontactsgroup.groupno
	END
	ELSE
	BEGIN;
		UPDATE ContactsGroup SET Memo=contacts_setcontactsgroup.memo WHERE GroupNo=contacts_setcontactsgroup.groupno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
