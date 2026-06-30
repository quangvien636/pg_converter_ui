-- ─── FUNCTION: contacts_getgroupinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getgroupinfo(integer);
CREATE OR REPLACE FUNCTION public.contacts_getgroupinfo(
    groupno integer
) RETURNS TABLE(
    groupno text,
    groupname text,
    reguserno text,
    regdate text,
    memo text,
    parentgno text,
    sort text,
    isdefault text,
    col9 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT GroupNo, GroupName, RegUserNo, RegDate, Memo, ParentGNo, Sort, IsDefault 
	,(SELECT COUNT(*) FROM ContactsGroupUser C WHERE C.GroupNo = ContactsGroup.GroupNo) AS UserCount
	FROM ContactsGroup
	WHERE GroupNo = contacts_getgroupinfo.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
