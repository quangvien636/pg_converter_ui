-- ─── PROCEDURE→FUNCTION: contacts_upsharegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_upsharegroup(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_upsharegroup(
    IN userno integer,
    IN groupno integer,
    IN parentno integer
) RETURNS void
AS $function$
BEGIN
	WITH RECURSIVE GroupTmp AS (select CG.*
from Contact_ShareGroup CG
WHERE CG.ParentNo=contacts_upsharegroup.parentno AND CG.IsDelete= FALSE AND CG.Sort <= (SELECT Sort FROM Contact_ShareGroup WHERE ShareGroupNo=contacts_upsharegroup.groupno)
ORDER BY Sort DESC),
GroupUpdate AS(SELECT T.ShareGroupNo,T1.Sort
FROM GroupTmp T
LEFT JOIN GroupTmp T1 ON T1.ShareGroupNo <> T.ShareGroupNo);
UPDATE Contact_ShareGroup
SET Sort= CGU.Sort,ModUserNo= contacts_upsharegroup.userno,ModDate=NOW()
FROM  GroupUpdate CGU
WHERE  CGU.ShareGroupNo=Contact_ShareGroup.ShareGroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.