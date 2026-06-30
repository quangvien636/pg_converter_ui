-- ─── PROCEDURE→FUNCTION: contacts_getpublicgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.contacts_getpublicgroup(character varying);
CREATE OR REPLACE FUNCTION public.contacts_getpublicgroup(
    IN langcode character varying DEFAULT 'KO'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT PG.PublicGroupNo AS Id,PG.PublicGroupName AS JsonName,COALESCE(CASE WHEN STRPOS(PG.PublicGroupName, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(PG.PublicGroupName)  WHERE NAME=contacts_getpublicgroup.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(PG.PublicGroupName)  WHERE NAME='KO')) ELSE PG.PublicGroupName END,'') AS Name , PG.ParentNo ,
	COALESCE(SU.ShareNumber,0) AS ShareNumber
	FROM  Contact_PublicGroup PG
	LEFT JOIN  ( SELECT P.PublicGroupNo, Count(P.PublicGroupNo) AS ShareNumber
				FROM Contact_PublicGroupUser  P
				INNER JOIN ContactsUser U ON U.Seq = P.UserSeq AND U.UseYn='Y'
				WHERE P.IsDelete= FALSE
				GROUP BY P.PublicGroupNo) SU ON SU.PublicGroupNo = PG.PublicGroupNo	
	WHERE PG.IsDelete= FALSE
	ORDER BY  PG.ParentNo, PG.Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
