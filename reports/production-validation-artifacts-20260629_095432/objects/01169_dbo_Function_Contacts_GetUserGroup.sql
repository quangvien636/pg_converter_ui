-- ─── FUNCTION: contacts_getusergroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getusergroup(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getusergroup(
    reguserno integer,
    userno integer,
    groupno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    groupname character varying;
    groupcount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	IF GroupNo = 0
	BEGIN
		RETURN QUERY
		SELECT /* TOP 1 */ GroupName = b.GroupName FROM ContactsGroupUser a
		INNER JOIN ContactsGroup b ON a.GroupNo=b.GroupNo
		WHERE a.UserSeq=contacts_getusergroup.userno AND a.RegUserNo=contacts_getusergroup.reguserno
	END
	ELSE
	BEGIN
		SELECT GroupName = b.GroupName FROM ContactsGroupUser a
		INNER JOIN ContactsGroup b ON a.GroupNo=b.GroupNo
		WHERE a.UserSeq=contacts_getusergroup.userno AND a.RegUserNo=contacts_getusergroup.reguserno AND a.GroupNo IN (select TreeID from public."GetChildGroup"(RegUserNo,GroupNo))
	END

	SELECT GroupCount = COUNT(*) FROM ContactsGroupUser
	WHERE UserSeq=contacts_getusergroup.userno AND RegUserNo=contacts_getusergroup.reguserno

	IF GroupCount = 1
	BEGIN
		RETURN QUERY
		SELECT COALESCE(GroupName,'')
	END
	ELSE
	BEGIN
		RETURN QUERY
		SELECT COALESCE(GroupName,'') + ';' || CONVERT(VARCHAR(10),GroupCount - 1)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
