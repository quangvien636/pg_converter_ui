-- ─── PROCEDURE→FUNCTION: contacts_uppublicgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_uppublicgroup(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_uppublicgroup(
    IN userno integer,
    IN groupno integer,
    IN parentno integer
) RETURNS void
AS $function$
BEGIN
	WITH RECURSIVE GroupTmp AS (select CG.*
from Contact_PublicGroup CG
WHERE CG.ParentNo=contacts_uppublicgroup.parentno AND CG.IsDelete= FALSE AND CG.Sort <= (SELECT Sort FROM Contact_PublicGroup WHERE PublicGroupNo=contacts_uppublicgroup.groupno )
ORDER BY Sort DESC),
GroupUpdate AS(SELECT T.PublicGroupNo,T1.Sort
FROM GroupTmp T
LEFT JOIN GroupTmp T1 ON T1.PublicGroupNo <> T.PublicGroupNo);
UPDATE Contact_PublicGroup
SET Sort= CGU.Sort,ModUserNo= contacts_uppublicgroup.userno,ModDate=NOW()
FROM  GroupUpdate CGU
WHERE  CGU.PublicGroupNo=Contact_PublicGroup.PublicGroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.