-- ─── FUNCTION: contacts_changegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_changegroup(integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_changegroup(
    groupno integer DEFAULT 689,
    userseqlist character varying DEFAULT '7996,7995'
) RETURNS SETOF record
-- TODO: replace SETOF record — add RETURNS TABLE(col1 type, col2 type, ...)
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	UPDATE ContactsGroupUser SET GroupNo = contacts_changegroup.groupno WHERE UserSeq IN (SELECT * FROM fnStringtoListInt(UserSeqList))

END;
--UPDATE ContactsGroupUser SET GroupNo = 689 WHERE UserSeq IN (SELECT * FROM fnStringtoListInt('7996,7995'))

--SELECT * FROM ContactsGroupUser WHERE UserSeq IN  (SELECT * FROM fnStringtoListInt('7996,7995'))
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
