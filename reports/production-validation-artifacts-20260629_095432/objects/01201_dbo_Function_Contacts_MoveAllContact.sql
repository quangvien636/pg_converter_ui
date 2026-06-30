-- ─── FUNCTION: contacts_moveallcontact ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_moveallcontact(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_moveallcontact(
    userno integer DEFAULT 70,
    groupno integer DEFAULT 687,
    newgroupno integer DEFAULT 672
) RETURNS void
AS $function$
BEGIN
UPDATE G  

SET G.GroupNo=contacts_moveallcontact.newgroupno
FROM ContactsGroupUser AS G
INNER JOIN ContactsUser AS U ON G.UserSeq= U.Seq AND U.RegUserNo=contacts_moveallcontact.userno AND U.UseYn='Y'
where G.GroupNo=contacts_moveallcontact.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
