-- ─── PROCEDURE→FUNCTION: contacts_searchmobi ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_searchmobi(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_searchmobi(
    IN userno integer,
    IN serchtext character varying,
    IN type integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM (SELECT
				CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
				,CONVERT(INT, ROW_NUMBER() OVER (
				ORDER BY 
					U.LastName ASC
				)) AS RowNum		
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				FROM (SELECT * FROM ContactsUser WHERE RegUserNo=contacts_searchmobi.userno AND UseYn='Y') U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq	
				LEFT JOIN ContactsNumber CN ON CN.UserSeq=U.Seq			
				WHERE U.Seq IN (SELECT MAX(Seq) FROM ContactsUser WHERE RegUserNo=contacts_searchmobi.userno GROUP BY (FirstName+LastName)) AND
				((U.LastName || ' ' || U.FirstName) ILIKE '%' || SerchText || '%' or (U.FirstName || ' ' || U.LastName) ILIKE '%' || SerchText || '%' or CN.Value ILIKE '%' || SerchText || '%') 
			
				GROUP BY 			
				U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				) T;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
