-- ─── FUNCTION: contacts_insertgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_insertgroup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_insertgroup(
    userno integer,
    grpname character varying,
    parentno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ Sort = Sort FROM ContactsGroup 
	WHERE RegUserNo = contacts_insertgroup.userno AND ParentGNo = contacts_insertgroup.parentno
	ORDER BY Sort DESC
		
	INSERT INTO ContactsGroup (GroupName, ParentGNo, RegUserNo, Sort,RegDate,IsDefault,UseYn)
	VALUES (GrpName, ParentNo, UserNo, Sort+1,NOW(),'0','Y')
	
	SET GroupNo = lastval()
	RETURN QUERY
	SELECT GroupNo AS GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
