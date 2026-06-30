-- ─── FUNCTION: contacts_getdepartmentboxcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getdepartmentboxcount(integer);
CREATE OR REPLACE FUNCTION public.contacts_getdepartmentboxcount(
    reguserno integer
) RETURNS TABLE(
    seq text
)
AS $function$
BEGIN

RETURN QUERY
select count(T.seq) from (
	SELECT distinct u.* FROM ContactsGroupUser G
	INNER JOIN ContactsUser U ON U.Seq = G.UserSeq AND U.UseYn='Y'
	inner join ContactsGroup cg on cg.groupno=g.groupno
	WHERE (U.RegUserNo=contacts_getdepartmentboxcount.reguserno and SUBSTRING(U.Share,1,3)='200') or (SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(RegUserNo) DP ON DP.DepartNo = C.DepartNo))) 
	) as T;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
