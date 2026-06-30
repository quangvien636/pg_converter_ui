-- ─── PROCEDURE→FUNCTION: contacts_updatesortdownofgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.contacts_updatesortdownofgroup(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatesortdownofgroup(
    IN reguserno integer DEFAULT 70,
    IN groupno integer DEFAULT 643,
    IN parentno integer DEFAULT 641
) RETURNS void
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
WITH GroupTmp AS (select /* /* TOP 2 */ */ CG.* 
from ContactsGroup CG 
WHERE CG.RegUserNo=contacts_updatesortdownofgroup.reguserno AND CG.ParentGNo=contacts_updatesortdownofgroup.parentno AND CG.UseYn='Y' AND CG.Sort >= (SELECT Sort FROM ContactsGroup WHERE GroupNo=contacts_updatesortdownofgroup.groupno)
ORDER BY Sort ASC)
,
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
