-- ─── FUNCTION: contacts_gettopcategory ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_gettopcategory(integer);
CREATE OR REPLACE FUNCTION public.contacts_gettopcategory(
    reguserno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
RETURN QUERY
SELECT /* /* TOP 1 */ */ *FROM 
(SELECT ROW_NUMBER() OVER(ORDER BY RegDate ASC) ROWNUM, GroupNo, GroupName  
 FROM ContactsGroup WHERE RegUserNo = contacts_gettopcategory.reguserno and ParentGNo = 0) a;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
