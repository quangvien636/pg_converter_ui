-- ─── FUNCTION: contacts_getallgroupsrestore ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getallgroupsrestore(integer);
CREATE OR REPLACE FUNCTION public.contacts_getallgroupsrestore(
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
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq 
		WHERE C.GroupNo = ContactsGroup.GroupNo
	) AS UserCount,
	UseYn
	FROM ContactsGroup 
	WHERE RegUserNo=contacts_getallgroupsrestore.reguserno 
	ORDER BY Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
