-- ─── FUNCTION: contacts_getgroupbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getgroupbyuser(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getgroupbyuser(
    reguserno integer DEFAULT '',
    userseq integer DEFAULT 0
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


 IF ((SELECT COUNT(*) FROM ContactsGroup  WHERE RegUserNo=contacts_getgroupbyuser.reguserno AND UseYn='Y')<=0)
 BEGIN
	EXEC Contacts_InsertGroup RegUserNo,'임시 그룹',0
 END


	RETURN QUERY
	SELECT distinct c.GroupNo, c.GroupName, c.RegUserNo, c.RegDate, c.Memo, c.ParentGNo, c.Sort, c.IsDefault, 
	(
		SELECT COUNT(*) 
		FROM ContactsGroupUser Cc
		INNER JOIN ContactsUser U ON U.Seq = Cc.UserSeq AND U.UseYn='Y'
		WHERE Cc.GroupNo = c.GroupNo
	) AS UserCount,
	UseYn
	FROM ContactsGroup c
	left join ContactsGroupUser g on c.groupno=g.groupno
	WHERE c.RegUserNo=contacts_getgroupbyuser.reguserno AND c.UseYn='Y' --and --g.userseq=UserSeq
	 ORDER BY c.Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
