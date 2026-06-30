-- ─── FUNCTION: contacts_getuser_groupinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuser_groupinfo(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_groupinfo(
    reguserno integer,
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT G.* FROM ContactsGroupUser U
	INNER JOIN ContactsGroup G ON G.GroupNo = U.GroupNo
	WHERE U.UserSeq=contacts_getuser_groupinfo.userno AND U.RegUserNo = contacts_getuser_groupinfo.reguserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
