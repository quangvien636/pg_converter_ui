-- ─── PROCEDURE→FUNCTION: contacts_getalluser_distinct ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getalluser_distinct(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getalluser_distinct(
    IN reguserno integer,
    IN currpage integer DEFAULT 1,
    IN recodperpage integer DEFAULT 20
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	WITH s AS
		(
			SELECT ROW_NUMBER() 
				OVER(ORDER BY Seq DESC) AS RowNum,Seq,FirstName,LastName,RegUserNo,Memo,RegDate,Photo,ModDate,CallName,ViewCount,(FirstName+LastName) as FullName
				--,(SELECT COUNT(*) FROM ContactsUser WHERE  Seq IN  (select MAX(Seq) AS SEQ FROM ContactsUser WHERE RegUserNo=RegUserNo GROUP BY FirstName+LastName)) as counts
			FROM ContactsUser Cu
			WHERE Seq IN  (select MAX(Seq) AS SEQ FROM ContactsUser WHERE RegUserNo=contacts_getalluser_distinct.reguserno   GROUP BY FirstName+LastName)
		  AND RegUserNo=contacts_getalluser_distinct.reguserno AND UseYn='Y'	
		)
		RETURN QUERY
		Select * , (select COUNT(*) FROM s) As counts From s 
		Where RowNum Between 
			(currPage - 1)*recodperpage+1 
			AND currPage*recodperpage	
			ORDER BY Seq DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
