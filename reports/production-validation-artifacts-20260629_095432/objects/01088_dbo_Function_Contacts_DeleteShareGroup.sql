-- ─── FUNCTION: contacts_deletesharegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_deletesharegroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_deletesharegroup(
    userno integer,
    groupno integer
) RETURNS TABLE(
    groupno text
)
AS $function$
BEGIN

	UPDATE  Contact_ShareGroup SET IsDelete = TRUE,  ModUserNo=contacts_deletesharegroup.userno,ModDate=NOW()
	WHERE ShareGroupNo=contacts_deletesharegroup.groupno
	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
