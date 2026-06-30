-- ─── FUNCTION: contacts_insertsharegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_insertsharegroup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_insertsharegroup(
    userno integer DEFAULT 70,
    sharegroupname character varying DEFAULT '{\"KO\":\"Share 001\",\"EN\":\"Share 001\",\"VN\":\"Share 001\",\"CH\":\"Share 001\",\"JP\":\"Share 001\"}',
    parentno integer DEFAULT 0
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ Sort = Sort FROM Contact_ShareGroup 
	WHERE ParentNo = contacts_insertsharegroup.parentno
	ORDER BY Sort DESC;
	INSERT INTO Contact_ShareGroup (ShareGroupName, ParentNo, RegUserNo,ModUserNo, Sort)
	VALUES (ShareGroupName, ParentNo, UserNo,UserNo, Sort+1)
	RETURN QUERY
	SELECT CAST(lastval() AS INT) ShareGroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
