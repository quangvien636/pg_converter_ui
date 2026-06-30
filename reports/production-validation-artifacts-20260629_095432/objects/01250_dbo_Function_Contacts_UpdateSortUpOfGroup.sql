-- ─── FUNCTION: contacts_updatesortupofgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updatesortupofgroup(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatesortupofgroup(
    reguserno integer,
    groupno integer,
    parentno integer
) RETURNS void
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	WITH GroupTmp AS (select /* /* TOP 2 */ */ CG.* 
from ContactsGroup CG 
WHERE CG.RegUserNo=contacts_updatesortupofgroup.reguserno AND CG.ParentGNo=contacts_updatesortupofgroup.parentno AND CG.UseYn='Y' AND CG.Sort <= (SELECT Sort FROM ContactsGroup WHERE GroupNo=contacts_updatesortupofgroup.groupno)
ORDER BY Sort DESC),
GroupUpdate AS(SELECT T.GroupNo,T1.Sort
FROM GroupTmp T 
LEFT JOIN GroupTmp T1 ON T1.GroupNo <> T.GroupNo);
UPDATE ContactsGroup 
SET ContactsGroup.Sort= CGU.Sort
FROM  GroupUpdate CGU WHERE  CGU.GroupNo=ContactsGroup.GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
