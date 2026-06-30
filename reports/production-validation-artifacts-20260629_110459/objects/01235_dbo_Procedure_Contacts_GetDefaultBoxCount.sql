-- ─── PROCEDURE→FUNCTION: contacts_getdefaultboxcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getdefaultboxcount(integer);
CREATE OR REPLACE FUNCTION public.contacts_getdefaultboxcount(
    IN reguserno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
select count(T.seq) from (
	SELECT distinct u.* FROM ContactsGroupUser G
	INNER JOIN ContactsUser U ON U.Seq = G.UserSeq AND U.UseYn='Y'
	inner join ContactsGroup cg on cg.groupno=g.groupno
	WHERE   
	--U.RegUserNo=RegUserNo and
	(U.RegUserNo=contacts_getdefaultboxcount.reguserno Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(RegUserNo) DP ON DP.DepartNo = C.DepartNo)))) 
	--and cg.isdefault='0' and 
	--cg.UseYn='Y' AND 
	--G.GroupNo=0
	) as T;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
