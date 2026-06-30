-- ─── FUNCTION: contacts_updatepublicgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updatepublicgroup(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatepublicgroup(
    userno integer,
    groupname character varying,
    groupno integer
) RETURNS TABLE(
    groupno text
)
AS $function$
BEGIN

	UPDATE  Contact_PublicGroup SET PublicGroupName =contacts_updatepublicgroup.groupname,  ModUserNo=contacts_updatepublicgroup.userno,ModDate=NOW()
	WHERE PublicGroupNo=contacts_updatepublicgroup.groupno
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
