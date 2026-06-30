-- ─── FUNCTION: contacts_deletepublicgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_deletepublicgroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_deletepublicgroup(
    userno integer DEFAULT 70,
    groupno integer DEFAULT 12
) RETURNS TABLE(
    groupno text
)
AS $function$
BEGIN

	UPDATE  Contact_PublicGroup SET IsDelete = TRUE,  ModUserNo=contacts_deletepublicgroup.userno,ModDate=NOW()
	WHERE PublicGroupNo=contacts_deletepublicgroup.groupno
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
