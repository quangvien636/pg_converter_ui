-- ─── PROCEDURE→FUNCTION: contacts_getusergroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.contacts_getusergroup(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getusergroup(
    IN reguserno integer,
    IN userno integer,
    IN groupno integer
) RETURNS SETOF record
AS $function$
DECLARE
    groupname character varying;
    groupcount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	IF GroupNo = 0 THEN
		RETURN QUERY
		SELECT /* TOP 1 */ GroupName = b.GroupName FROM ContactsGroupUser a
		INNER JOIN ContactsGroup b ON a.GroupNo=b.GroupNo
		WHERE a.UserSeq=contacts_getusergroup.userno AND a.RegUserNo=contacts_getusergroup.reguserno
	END IF;
	ELSE
		SELECT b.GroupName INTO groupname FROM ContactsGroupUser a
		INNER JOIN ContactsGroup b ON a.GroupNo=b.GroupNo
		WHERE a.UserSeq=contacts_getusergroup.userno AND a.RegUserNo=contacts_getusergroup.reguserno AND a.GroupNo IN (select TreeID from public."GetChildGroup"(RegUserNo,GroupNo))
	END IF;

	SELECT COUNT(*) INTO groupcount FROM ContactsGroupUser
	WHERE UserSeq=contacts_getusergroup.userno AND RegUserNo=contacts_getusergroup.reguserno

	IF GroupCount = 1 THEN
		RETURN QUERY
		SELECT COALESCE(GroupName,'')
	END IF;
	ELSE
		RETURN QUERY
		SELECT COALESCE(GroupName,'') + ';' || CONVERT(VARCHAR(10),GroupCount - 1)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
