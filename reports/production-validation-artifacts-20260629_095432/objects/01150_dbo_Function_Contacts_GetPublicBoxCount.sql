-- ─── FUNCTION: contacts_getpublicboxcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getpublicboxcount(integer);
CREATE OR REPLACE FUNCTION public.contacts_getpublicboxcount(
    reguserno integer DEFAULT 70
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

WITH 	GroupUsers AS(SELECT GU.*,ROW_NUMBER() OVER(PARTITION BY GU.UserSeq, GU.GroupNo ORDER BY GU.RegDate) AS Nm FROM ContactsGroupUser GU)
RETURN QUERY
SELECT COUNT(T.seq) from (
	SELECT DISTINCT U.* 
	FROM  ContactsUser U
	LEFT JOIN  GroupUsers G ON U.Seq = G.UserSeq AND U.UseYn='Y'  AND G.Nm=1
	LEFT JOIN ContactsGroup cg on cg.groupno=g.groupno AND CG.UseYn='Y'
	WHERE SUBSTRING(U.Share,1,3)='300' AND U.UseYn = 'Y') as T;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
