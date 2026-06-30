-- ─── FUNCTION: contacts_getonerowchildgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getonerowchildgroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getonerowchildgroup(
    groupno integer,
    reguserno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN
RETURN QUERY
SELECT b.* FROM 
(select * FROM public."GetChildGroup"(RegUserNo,groupno) WHERE Level=2) a,
(select *from ContactsGroup where RegUserNo = contacts_getonerowchildgroup.reguserno) b where a.TreeID = b.GroupNo
order by b.Sort asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
