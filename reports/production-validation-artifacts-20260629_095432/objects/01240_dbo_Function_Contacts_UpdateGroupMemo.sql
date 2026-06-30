-- ─── FUNCTION: contacts_updategroupmemo ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updategroupmemo(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updategroupmemo(
    groupno integer,
    userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsGroup SET Memo = Memo 
	WHERE GroupNo = contacts_updategroupmemo.groupno 
	AND RegUserNo = contacts_updategroupmemo.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
