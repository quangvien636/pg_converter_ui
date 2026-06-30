-- ─── FUNCTION: contacts_uppublicgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_uppublicgroup(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_uppublicgroup(
    userno integer,
    groupno integer,
    parentno integer
) RETURNS void
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	WITH GroupTmp AS (select /* /* TOP 2 */ */ CG.* 
from Contact_PublicGroup CG 
WHERE CG.ParentNo=contacts_uppublicgroup.parentno AND CG.IsDelete= FALSE AND CG.Sort <= (SELECT Sort FROM Contact_PublicGroup WHERE PublicGroupNo=contacts_uppublicgroup.groupno )
ORDER BY Sort DESC),
GroupUpdate AS(SELECT T.PublicGroupNo,T1.Sort
FROM GroupTmp T 
LEFT JOIN GroupTmp T1 ON T1.PublicGroupNo <> T.PublicGroupNo);
UPDATE Contact_PublicGroup 
SET Contact_PublicGroup.Sort= CGU.Sort,Contact_PublicGroup.ModUserNo= contacts_uppublicgroup.userno,Contact_PublicGroup.ModDate=NOW()
FROM  GroupUpdate CGU 
WHERE  CGU.PublicGroupNo=Contact_PublicGroup.PublicGroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
