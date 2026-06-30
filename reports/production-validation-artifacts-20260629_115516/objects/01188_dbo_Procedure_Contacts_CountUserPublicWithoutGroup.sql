-- ─── PROCEDURE→FUNCTION: contacts_countuserpublicwithoutgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_countuserpublicwithoutgroup();
CREATE OR REPLACE FUNCTION public.contacts_countuserpublicwithoutgroup(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT COUNT(U.seq)
	FROM  ContactsUser U
	LEFT JOIN  Contact_PublicGroupUser G ON U.Seq = G.UserSeq AND U.UseYn='Y'  AND G.IsDelete= FALSE
	WHERE SUBSTRING(U.Share,1,3)='300' AND U.UseYn = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
