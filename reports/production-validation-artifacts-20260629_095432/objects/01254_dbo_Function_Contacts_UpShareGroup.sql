-- ─── FUNCTION: contacts_upsharegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_upsharegroup(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_upsharegroup(
    userno integer,
    groupno integer,
    parentno integer
) RETURNS void
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	WITH GroupTmp AS (select /* /* TOP 2 */ */ CG.* 
from Contact_ShareGroup CG 
WHERE CG.ParentNo=contacts_upsharegroup.parentno AND CG.IsDelete= FALSE AND CG.Sort <= (SELECT Sort FROM Contact_ShareGroup WHERE ShareGroupNo=contacts_upsharegroup.groupno)
ORDER BY Sort DESC),
GroupUpdate AS(SELECT T.ShareGroupNo,T1.Sort
FROM GroupTmp T 
LEFT JOIN GroupTmp T1 ON T1.ShareGroupNo <> T.ShareGroupNo);
UPDATE Contact_ShareGroup 
SET Contact_ShareGroup.Sort= CGU.Sort,Contact_ShareGroup.ModUserNo= contacts_upsharegroup.userno,Contact_ShareGroup.ModDate=NOW()
FROM  GroupUpdate CGU 
WHERE  CGU.ShareGroupNo=Contact_ShareGroup.ShareGroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
