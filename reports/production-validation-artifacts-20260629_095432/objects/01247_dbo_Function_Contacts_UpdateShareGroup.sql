-- ─── FUNCTION: contacts_updatesharegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updatesharegroup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatesharegroup(
    userno integer,
    groupname character varying,
    groupno integer
) RETURNS TABLE(
    groupno text
)
AS $function$
BEGIN

	UPDATE  Contact_ShareGroup SET ShareGroupName =contacts_updatesharegroup.groupname,  ModUserNo=contacts_updatesharegroup.userno,ModDate=NOW()
	WHERE ShareGroupNo=contacts_updatesharegroup.groupno
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
