-- ─── FUNCTION: contacts_getallgroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getallgroups(integer);
CREATE OR REPLACE FUNCTION public.contacts_getallgroups(
    reguserno integer
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
	SELECT GroupNo, GroupName, RegUserNo, RegDate, Memo, ParentGNo, Sort, IsDefault, 
	(
		SELECT COUNT(*) 
		FROM ContactsGroupUser C
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq AND U.UseYn='Y'
		WHERE C.GroupNo = ContactsGroup.GroupNo
	) AS UserCount,
	UseYn
	FROM ContactsGroup 
	WHERE RegUserNo=contacts_getallgroups.reguserno AND UseYn='Y'
	ORDER BY Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
