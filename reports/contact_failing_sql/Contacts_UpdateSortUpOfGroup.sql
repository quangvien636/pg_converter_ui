-- ─── PROCEDURE→FUNCTION: contacts_updatesortupofgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.contacts_updatesortupofgroup(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatesortupofgroup(
    IN reguserno integer,
    IN groupno integer,
    IN parentno integer
) RETURNS void
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	WITH RECURSIVE GroupTmp AS (select /* /* TOP 2 */ */ CG.*
from ContactsGroup CG
WHERE CG.RegUserNo=contacts_updatesortupofgroup.reguserno AND CG.ParentGNo=contacts_updatesortupofgroup.parentno AND CG.UseYn='Y' AND CG.Sort <= (SELECT Sort FROM ContactsGroup WHERE GroupNo=contacts_updatesortupofgroup.groupno)
ORDER BY Sort DESC),
GroupUpdate AS(SELECT T.GroupNo,T1.Sort
FROM GroupTmp T
LEFT JOIN GroupTmp T1 ON T1.GroupNo <> T.GroupNo);
UPDATE ContactsGroup
SET Sort= CGU.Sort
FROM  GroupUpdate CGU WHERE  CGU.GroupNo=ContactsGroup.GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.