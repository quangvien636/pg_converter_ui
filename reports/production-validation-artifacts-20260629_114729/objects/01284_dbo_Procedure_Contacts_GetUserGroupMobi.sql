-- ─── PROCEDURE→FUNCTION: contacts_getusergroupmobi ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getusergroupmobi(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getusergroupmobi(
    IN reguser integer,
    IN groupid integer,
    IN currpage integer DEFAULT 1,
    IN recodperpage integer DEFAULT 20
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	WITH s AS
		(
			SELECT ROW_NUMBER() 
				OVER(ORDER BY CG.UserSeq DESC) AS RowNum,CG.UserSeq ,
				(SELECT COUNT(*) FROM ContactsGroupUser CG INNER JOIN ContactsUser CU ON CG.UserSeq=CU.Seq
					WHERE CG.RegUserNo=contacts_getusergroupmobi.reguser 
						  AND CG.GroupNo=contacts_getusergroupmobi.groupid 
						  AND CU.UseYn='Y') as counts
			FROM ContactsGroupUser CG
			INNER JOIN ContactsUser CU
			ON CG.UserSeq=CU.Seq
			WHERE CG.RegUserNo=contacts_getusergroupmobi.reguser 
				  AND CG.GroupNo=contacts_getusergroupmobi.groupid 
				  AND CU.UseYn='Y'
		)
		RETURN QUERY
		Select * From s 
		Where RowNum Between 
			(currPage - 1)*recodperpage+1 
			AND currPage*recodperpage;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
