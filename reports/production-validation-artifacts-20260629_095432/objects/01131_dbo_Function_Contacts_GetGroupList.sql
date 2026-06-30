-- ─── FUNCTION: contacts_getgrouplist ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getgrouplist();
CREATE OR REPLACE FUNCTION public.contacts_getgrouplist(
) RETURNS TABLE(
    groupno text,
    groupname text,
    memo text,
    parentgno text,
    sort text,
    isdefault text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT 
		GroupNo,
		GroupName,
		Memo,
		ParentGNo,
		Sort,
		IsDefault
	FROM ContactsGroup
	WHERE RegUserNo = UserNo AND UseYn='Y' ORDER BY Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
