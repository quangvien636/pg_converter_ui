-- ─── FUNCTION: contacts_getcountchilduser ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getcountchilduser(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getcountchilduser(
    seq integer,
    reguserno integer
) RETURNS TABLE(
    treeid text
)
AS $function$
BEGIN
RETURN QUERY
select COUNT(*) count FROM ContactsUser WHERE UseYn = 'Y'  AND Seq IN
 (SELECT UserSeq from ContactsGroupUser WHERE RegUserNo = contacts_getcountchilduser.reguserno
AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(RegUserNo, Seq)));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
