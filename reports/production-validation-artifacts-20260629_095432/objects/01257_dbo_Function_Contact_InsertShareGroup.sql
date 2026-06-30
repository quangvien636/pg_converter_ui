-- ─── FUNCTION: contact_insertsharegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contact_insertsharegroup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contact_insertsharegroup(
    userno integer,
    sharename character varying,
    parentno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ Sort = Sort FROM Contact_ShareGroup 
	WHERE  ParentNo = contact_insertsharegroup.parentno
	ORDER BY Sort DESC
		
	INSERT INTO Contact_ShareGroup (ShareGroupName, ParentNo, RegUserNo, Sort,RegDate,IsDelete)
	VALUES (ShareName, ParentNo, UserNo, Sort+1,NOW(),'FALSE')
	
	SET GroupNo = lastval()
	RETURN QUERY
	SELECT GroupNo AS GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
